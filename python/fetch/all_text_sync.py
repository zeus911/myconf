#!/usr/bin python
# -*- coding: utf-8 -*-
import datetime
import urllib2
from common.envmod import *
import fff64_vip
import novel941_vip
import se8_vip
import sexx77_vip
import x2246_vip
import jjr128_vip
import g6858_vip
import aaw51_vip
import seshu_vip
import mayi01_vip

def pase1():
    fff64_vip.parseText()
    #novel941_vip.parseText()
    x2246_vip.parseText()
    jjr128_vip.parseText()
    g6858_vip.parseText()
def pase2():
    ##aaw51_vip.parseText()
    ####seshu_vip.parseText()
    se8_vip.startWork()
    se8_vip.parseText()
    ####mayi01_vip.parseText()
if __name__ == '__main__':
    val = argsMap.get("-p",0)
    if int(val)==1:
        pase1()
    elif int(val)==2:
        pase2()
    
    