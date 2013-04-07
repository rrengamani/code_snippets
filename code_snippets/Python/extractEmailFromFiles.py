#!/usr/bin/env python
#title           :extractEmailFromFiles.py
#description     :This will extract all email IDs from a file.
#author          :rengamanir
#date            :20121120
#version         :1.0
#usage           :python extractEmailFromFiles.py <Input file> <outputfile>
#notes           :
#python_version  :2.7  
#==============================================================================

import os
import re
import csv
import sys
 
# vars for filenames

if len(sys.argv) != 3: print "Required Arguments: 2 => <Input file> <outputfile>"; raise SystemExit

filename = sys.argv[1]
f = open (sys.argv[2], "w+")

# read Input file
if os.path.exists(filename):
    data = open(filename,'r')
    bulkemails = data.read()
else:
    print "File not found."
    raise SystemExit

# Regex to extract emails 
regexp_email = r'''([\w\-\.+]+@\w[\w\-]+\.+[\w\-]+)'''
pattern = re.compile(regexp_email)

results = re.findall(pattern,bulkemails)    
emails = ""   

for x in results:
    emails += str(x)+"\n"   
    f.write(emails)

data.close()
f.close()

 
