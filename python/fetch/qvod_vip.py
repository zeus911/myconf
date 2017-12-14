#!/usr/bin python
# -*- coding: utf-8 -*-
import datetime
import urllib2
import threading
from BeautifulSoup import BeautifulSoup
from common.envmod import *
from common import common
from common import typeutil
from common import db_ops
from common import MyQueue
from qvod import *
import re
import sys
import getopt
reload(sys)
sys.setdefaultencoding('utf8')
queue = MyQueue.MyQueue(200000)
maxCount = 2


class HandleThread(threading.Thread):

    def __init__(self, name, queue):
        threading.Thread.__init__(self, name=name)
        self.t_name = name
        self.t_queue = queue

    def run(self):
        while(True):
            try:
                print queue.qsize()
                obj = queue.get(timeout=30)
                if obj != None:
                    obj.run()
            except Exception as e:
                print common.format_exception(e)
                pass

if __name__ == '__main__':

    for i in range(0, maxCount):
        worker = HandleThread("work-%s" % (i), queue)
        worker.start()
    video.videoParse(queue)