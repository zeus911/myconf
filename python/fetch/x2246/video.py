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
                print '2246x 解析完成 ', ch['channel'], ' ---', i, '页'
    def videoChannel(self):
        ahrefs = self.header()
        objs =[]
        for ahref in ahrefs:
            obj = {}
            obj['url']=ahref.get('href')
            obj['name']=ahref.text
            obj['baseurl']=baseurl
            obj['updateTime']=datetime.datetime.now()
            obj['pic']=''
            obj['rate']=1.2
            obj['channel']="www.2284yy.com"+obj['url']
            obj['showType']=3
            obj['channelType']='normal'
            objs.append(obj)
        return  objs
    def videoParse(self, channel, url):
        dataList = []
        soup = self.fetchUrl(url)
        div = soup.first("div", {"class": "box-video-list"})
        if div!=None:
            lis = div.findAll('li')
            for li in lis:
                ahref = li.first('a')
                if ahref!=None:
                    mp4Url  = self.parseDomVideo(ahref.get("href"))
                    if mp4Url==None:
                        continue
                    obj = {}
                    obj['url'] = mp4Url
                    obj['pic'] = ahref.get("data-original")
                    obj['name'] = ahref.get('title')
                    print obj['name'],mp4Url,obj['pic']
    
                    videourl = urlparse(obj['url'])
                    obj['path'] = videourl.path
                    obj['updateTime'] = datetime.datetime.now()
                    obj['channel'] = channel
                    obj['baseurl'] = baseurl
                    dataList.append(obj)
            dbVPN = db.DbVPN()
            ops = db_ops.DbOps(dbVPN)
            for obj in dataList:
                ops.inertVideo(obj,"normal",baseurl)
    
            print 'x2246 video --解析完毕 ; channel =', channel, '; len=', len(dataList), url
            dbVPN.commit()
            dbVPN.close()

    def parseDomVideo(self, url):
        header = {'User-Agent':
                  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36', "Referer": url}
        try:
            soup = self.fetchUrl(url, header)
            scripts = soup.findAll("script")
            for script in scripts:
                texts = script.text.replace(" ","").split(";")
                for text in texts:
                    match = playVideo.search(text)
                    if match!=None:
                        return "%s%s%s"%("https://cdn.846u.com",match.group(1),"m3u8")
                    match = playVideo2.search(text)
                    if match!=None:
                        return "%s%s%s"%("https://cdn.846u.com",match.group(1),"m3u8")
                    match = playVideo3.search(text)
                    if match!=None:
                        return "%s%s%s"%("http",match.group(1),"m3u8")
            print url,'没有mp4'
            return None
        except Exception as e:
            print common.format_exception(e)
            return None

def videoParse(queue):
    queue.put(VideoParse())
