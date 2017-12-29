#!/usr/bin python
# -*- coding: utf-8 -*-
from baseparse import *
from urlparse import urlparse


class VideoParse(BaseParse):

    def __init__(self):
        pass

    def run(self):
        for i in range(1, maxPage):
            self.videoParse(channel, videoUrl % (i))

    def videoParse(self, channel, url):
        dataList = []
        soup = self.fetchUrl(url)
        alist = soup.findAll("a", {"class": "thumb-video"})
        for aitem in alist:
            img = aitem.first('img')
            picUrl = img.get('src')
            name = aitem.get('title')
            obj = {}
            obj['name'] = name
            mp4Url = self.parseDomVideo(aitem.get("href"))
            if mp4Url == None:
                print '没有mp4 文件:', aitem.get("href")
                continue
            obj['url'] = mp4Url
            videourl = urlparse(obj['url'])
            obj['path'] = videourl.path
            obj['updateTime'] = datetime.datetime.now()
            obj['pic'] = picUrl
            obj['channel'] = channel
            dataList.append(obj)
        dbVPN = db.DbVPN()
        ops = db_ops.DbOps(dbVPN)
        for obj in dataList:
            ops.inertVideo(obj)

        print '69vj video --解析完毕 ; channel =', channel, '; len=', len(dataList), url
        dbVPN.commit()
        dbVPN.close()

    def parseDomVideo(self, url):
        header = {'User-Agent':
                  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36', "Referer": url}

        soup = self.fetchUrl(url, header)
        iframe = soup.first("iframe")
        if iframe == None:
            return None
        url = "http:%s" % (iframe.get("src"))
        header = {'User-Agent':
                  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36', "Referer": url}

        soup = self.fetchUrl(url, header)
        source = soup.first("source", {"type": "video/mp4"})
        print source.get("src")
        if source != None:
            return source.get("src")
        return None


def videoParse(queue):
    queue.put(VideoParse())
