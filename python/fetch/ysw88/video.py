#!/usr/bin python
# -*- coding: utf-8 -*-
from baseparse import *
from urlparse import urlparse
from common import common
from urllib import unquote
import time
from fetch.profile import *

class VideoParse(BaseParse):

    def __init__(self):
        pass

    def run(self):
        dbVPN = db.DbVPN()
        ops = db_ops.DbOps(dbVPN)
        chs  = self.videoChannel()
        for ch in chs:
            ops.inertVideoChannel(ch)
        print ' channel ok; len=',len(chs)
        dbVPN.commit()
        dbVPN.close()
        for ch in chs:
            for i in range(1, maxVideoPage):
                url= ch['url']
                if i!=1:
                    url= "%s%s%s"%(ch['url'].replace('.html','-'),i,'.html')
                self.videoParse(ch['channel'], url)
                print '解析完成 ', ch['channel'], ' ---', i, '页'
    def videoChannel(self):
        channelList = []
        ahrefs = self.header()
        for ahref in ahrefs:
            obj={}
            obj['name']=ahref.text
            obj['url']=ahref.get('href')
            obj['baseurl']=baseurl
            obj['updateTime']=datetime.datetime.now()
            obj['pic']=''
            obj['rate']=1.2
            obj['channel']=obj['name']
            obj['showType']=3
            obj['channelType']='movie'
            channelList.append(obj)
#         channelList.reverse()
        return  channelList
    def videoParse(self, channel, url):
        dataList = []
        soup = self.fetchUrl(url)
        lis = soup.findAll("li", {"class": "p1 m1"})
        for li in lis:
            ahref = li.first('a')
            if ahref!=None:
                match = videoId.search(ahref.get("href"))
                if match!=None:
                    Id= match.group(3)
                    mp4Url  = self.parseDomVideo(Id)
                    if mp4Url==None:
                        continue
                    if mp4Url.count('.html')!=0 :
                        print mp4Url,"爱奇艺，忽略"
                        continue
                    obj = {}
                    obj['url'] = mp4Url
                    img = ahref.first("img")
                    if img.get('data-original').count("http")>0:
                        obj['pic'] = img.get('data-original')
                    else:
                        obj['pic'] = baseurl+img.get('data-original')
                    obj['name'] = ahref.get("title")
                    obj['path'] = "%s%s%s11"%(channel,"-",obj['name'])
                    print obj['path'],obj['url'],obj['pic']
                    obj['updateTime'] = datetime.datetime.now()
                    obj['channel'] = channel
                    obj['baseurl'] = baseurl
                    dataList.append(obj)
        dbVPN = db.DbVPN()
        ops = db_ops.DbOps(dbVPN)
        for obj in dataList:
            ops.inertVideo(obj,"normal",baseurl)

        print 'f8dy video --解析完毕 ; channel =', channel, '; len=', len(dataList), url
        dbVPN.commit()
        dbVPN.close()

    def parseDomVideo(self, url):
        header = {'User-Agent':
                  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36', "Referer": url}
        try:
#             soup = self.fetchUrl(url, header)
#             ul = soup.first('div',{"id":'vlink_1'})
#             if ul!=None:
#                 ahrefs = ul.findAll('a')
#                 for ahref in ahrefs:
            soup = self.fetchUrl("%s%s%s"%("/vod-play-id-",url,"-src-1-num-1.html"), header)
            main = soup.first("div",{"class":"player mb"})
            if main!=None:
                scripts = main.findAll("script")
                for sc in scripts:
                    texts = unquote(sc.text).split("$")
                    for text in texts:
                        match = videoApi.search(text)
                        if match!=None:
                            str= match.group(1)
                            return "%s%s%s"%("http",str,".m3u8")
            print url,'没有mp4'
            return None
        except Exception as e:
            print common.format_exception(e)
            return None

def videoParse(queue):
    queue.put(VideoParse())
