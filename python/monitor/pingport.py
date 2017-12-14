# -*- coding: utf-8 -*-
from common import db_ops
from common.envmod import *
import os
if __name__ == '__main__':
    dbVPN = db.DbVPN()
    ops = db_ops.DbOps(dbVPN)
    hosts = ops.getAllHost()
    for i in range(0, 2):
        for item in hosts:
            cmd = 'nc -u -n -v  %s -z %s ' % (item['gateway'],
                                              item['port'])
            textlist = os.popen(cmd).readlines()
            text = ''
            for line in textlist:
                text = text + line
            print text
            if text.find('succeeded') > 0:
                pass
            else:
                print item['gateway'], '---连不上，请检查'