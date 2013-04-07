#!/usr/bin/env python
#title           :bing_translator.py
#description     :This will translate text from any language to any.The user is responsible for signing up at azure market place to get secret token.
#		 : Sign up URL: http://msdn.microsoft.com/en-us/library/hh454950.aspx.
#author          :rengamanir
#date            :20130125
#version         :1.0
#usage           :python bing_translator.py <Input File> <Source Country Code> <Destination Country Code> <Output File.txt>
#notes           :
#python_version  :2.7  
#==============================================================================

# Specify utf-8 encoding and Import the modules needed to run the script.

# -*- coding: utf-8 -*-
import urllib, httplib
import json
import re
import time
import sys

class Token(object):
    def __init__(self, client_id, client_secret):
        self.client_id = client_id;
        self.client_secret = client_secret
        self.init = True
        self.token = None

    def getToken(self, re_init=False):
        if not self.init and not re_init:
            if time.time() - self.start_time < 580:
                return self.token
        self.init = False
        self.start_time = time.time()
        params = urllib.urlencode({'client_id': self.client_id, 'client_secret': self.client_secret,
                'scope': "http://api.microsofttranslator.com", "grant_type":"client_credentials"})
        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}

        conn = httplib.HTTPSConnection("datamarket.accesscontrol.windows.net")
        conn.request("POST", "/v2/OAuth2-13", params)
        rs = json.loads ( conn.getresponse().read() )
        self.token = rs[u'access_token']
        return self.token

class BingTranslator(object):
    def __init__(self, client_id, client_secret):
        self.token_obj = Token(client_id, client_secret)

    def unicode2utf8(self, text):
        try:
            if isinstance(text, unicode):
                text = text.encode('utf-8')
        except Exception as (e, msg):
            print e, msg
            pass
        return text

    def getText(self, xml):
        text = re.sub(r"<.+?>", " ", xml).strip()
        return text

    def getTranslation(self, conn, text, src, tgt, reinit_token = False):
        token = self.token_obj.getToken(reinit_token)
        headers = {'Authorization':'bearer %s' % token}
        dic = {}
        dic['from'] = src
        dic['to'] = tgt
        dic['text'] = self.unicode2utf8(text)
        addr = '/V2/Http.svc/Translate?' + urllib.urlencode(dic)
        conn.request("GET", addr, headers=headers)
        xml = conn.getresponse().read()
        return self.getText(xml)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        sys.exit("Usage <Input File> <Source Country Code> <Destination Country Code> <Output File.txt>")
    client_id = "rengamanir"
    # sign up and obtain access token from http://msdn.microsoft.com/en-us/library/hh454950.aspx.
    client_secret = "" 
    translator = BingTranslator (client_id, client_secret)
    conn = httplib.HTTPConnection('api.microsofttranslator.com')
    INPUT_FILE = sys.argv[1]
    Source_Cntry = sys.argv[2]
    Dest_Cntry = sys.argv[3]
    OUTPUT_FILE = sys.argv[4]
    num_lines = sum(1 for line in open(INPUT_FILE) if line.strip())
    lineCount = 1
    f = open(INPUT_FILE,'r')
    fo = open(OUTPUT_FILE, "w")
    
    for line in f.read().split('\n'):
     
        if not line.strip():
            continue
        
        #print translator.getTranslation ("""line""", Source_Cntry, Dest_Cntry)
        
        tq = translator.getTranslation (conn, line, Source_Cntry, Dest_Cntry)
        print "Processing Line:",lineCount,"of",num_lines
        fo.write(line+'\t'+tq+'\n')
        lineCount = lineCount + 1
    fo.close ()
    f.close ()