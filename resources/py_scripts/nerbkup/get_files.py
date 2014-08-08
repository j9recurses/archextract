# -*- coding: utf-8 -*-
#!/usr/bin/python

import os

basedir = "/home/j9/Desktop/archextract/public/src_corpora/John_Muir/input"

#grab the files
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']

count = 0
stuff = []
for f in all_files:
  fname = str(f)
  #if count < 100:
  doc_words    = open(f).readline()
  stuff.append(doc_words)
  #count = count +1
f = open('/home/j9/Desktop/nertest/myfile_test.txt','w')
for s in stuff:
 f.write(str(s) +"??" + fname + "\n")
f.close()
