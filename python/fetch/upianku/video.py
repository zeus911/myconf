#!/usr/bin python
# -*- coding: utf-8 -*-
from baseparse import *
from urlparse import urlparse
from common import common
from urllib import unquote
import time
import json
from fetch.profile import *
from urllib import unquote

class VideoParse(BaseParse):

    def __init__(self):
        pass

    def run(self):
        dbVPN = db.DbVPN()
        ops = db_ops.DbOps(dbVPN)
        chs = self.videoChannel()
        for item in chs:
            ops.inertVideoChannel(item)
        print 'upianku video -- channel ok;,len=',len(chs)
        dbVPN.commit()
        dbVPN.close()
        for item in chs:
            for i in range(1, maxVideoPage):
                url= item['url']
                if i!=1:
                    url= "%s%s%s%s"%(item['url'],"index",i,".html")
                self.videoParse(item['channel'], url)
                print '解析完成 ', item['channel'], ' ---', i, '页'
    def videoChannel(self):
        soup = self.fetchUrl('/')
        divs  = soup.findAll('div',{'class':'nav-c-share clearfix'})
        channelList =[]
        div = divs[1]
        if div!=None:
            ahrefs = div.findAll('a')
            for ahref in ahrefs:
                if ahref.get('href')!="/dianying/":
                    obj={}
                    obj['url']=ahref.get('href')
                    obj['baseurl']=baseurl
                    obj['updateTime']=datetime.datetime.now()
                    obj['pic']=''
                    obj['rate']=0.7
                    obj['channel']=obj['name']=ahref.text
                    obj['showType']=1
                    obj['channelType']='movie'
                    channelList.append(obj)
        return channelList
    def videoParse(self, channel, url):
        dataList = []
        soup = self.fetchUrl(url)
        div = soup.first("div",{"class":'filtrate-container-body'})
        lis = div.findAll("li")
        for li in lis:
            ahref = li.first('a')
            if ahref != None:
                obj = {}
                mp4Url = self.parseDomVideo(ahref.get("href"))
                if mp4Url == None:
                    print '没有mp4 文件:', ahref.get("href")
                    continue
                obj['url'] = mp4Url
                img = ahref.first("img")
                obj['pic'] = img.get("data-url")
                obj['name'] = img.get("alt")
                obj['path'] = "%s%s%s"%(channel,"-",obj['name'])
                obj['updateTime'] = datetime.datetime.now()
                if mp4Url.count("m3u8")==0:
                    obj['videoType'] = "webview"
                else:
                    obj['videoType'] = "normal"
                obj['channel'] = channel
                obj['baseurl'] = baseurl
                print obj['videoType'],obj['url'],obj['pic']
                dataList.append(obj)
        dbVPN = db.DbVPN()
        ops = db_ops.DbOps(dbVPN)
        for obj in dataList:
            ops.inertVideo(obj,obj['videoType'],baseurl)

        print 'upianku video --解析完毕 ; channel =', channel, '; len=', len(dataList), url
        dbVPN.commit()
        dbVPN.close()

    def parseDomVideo(self, url):
      
        try:
            soup = self.fetchUrl(url)
            div = soup.first("div",{"class":"details-con2-body"})
            if div!=None:
                ahref = div.first("a")
                if ahref!=None:
                    soup = self.fetchUrl(ahref.get("href"))
                    player = soup.first("div",{"class":"player-box details-body"})
                    if player!=None:
                        script = player.first("script")
                        if script!=None:
                            content = unquote(str(script.text))
                            match = regVideo.search(content)
                            if match!=None:
                                obj = json.loads(match.group(1))
                                data = obj.get('Data',[])
                                urlData = []
                                for item in data:
                                    itemData = item.get('playurls',[])
                                    for itemUrl in itemData:
                                        for itemurlOne in itemUrl:
                                            if itemurlOne.count('http')>0:
                                                urlData.append(itemurlOne)
                                for item in urlData:
                                    if item.count('m3u8'):
                                        return item
                                for item in urlData:
                                    if item.count('/share/'):
                                        return item
                                if len(urlData)>0:
                                    return urlData[0]
            print '没找到mp4'
            return None
        except Exception as e:
            print common.format_exception(e)
            return None

def videoParse(queue):
    queue.put(VideoParse())
