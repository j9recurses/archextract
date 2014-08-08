# -*- coding: utf-8 -*-
#!/usr/bin/python

import os
from optparse import OptionParser
import mysql.connector

def connect_db(dbuser, dbpasswd, dbhost, dbenviron):
  config = {
  'user': dbuser,
  'password': dbpasswd,
  'host': dbhost,
   'database': 'archextract_' + dbenviron,
  'raise_on_warnings': True,
  }
  cnx = mysql.connector.connect(**config)
  return cnx

def getfilesfrom_db(cid, cnx):
  sql = "select name, id from documents where collection_id = " + cid
  cursor = cnx.cursor()
  cursor.execute(sql)
  row = cursor.fetchall()
  filedict = {}
  for r in row:
      fname = r[0]
      filedict[r[1]] = str(fname)
  return filedict


##cmd opts##############
#EX: of cmd line args:
parser = OptionParser()
parser.add_option('-o', '--outdir', dest='outdir',
        help='directory of outfile')
parser.add_option('-b', '--basedir', dest='basedir',
        help='basedir to make infile from')
parser.add_option('-c', '--collectionname', dest='cn',
        help='collection name')
parser.add_option('-i', '--collectionid', dest='cid',
        help='collectionidlection id')
parser.add_option('-v', '--dbenviron', dest='dbenviron',
        help='db environment')
(opts, args) = parser.parse_args()

#EX:python /home/j9/Desktop/archextract/resources/py_scripts/ner_extract/get_ner_in_files.py -b /home/j9/Desktop/archextract/public/src_corpora/John_Muir/input -o /home/j9/Desktop/stemmertest/ -c John_Muir -i 8 -v development

if  opts.outdir is None or opts.dbenviron is None or opts.cn is None or opts.cid is None or opts.basedir is None:
  print "A mandatory option is missing\n"
  print opts
  parser.print_help()
  exit(-1)
else:
  basedir  = opts.basedir
  outdir = opts.outdir
  cid  = opts.cid
  cn = opts.cn
  dbenviron = opts.dbenviron
  outfile = outdir + "/" + cn + "_ner_infile.txt"


dbpasswd = "mypass"
dbuser = "myrailsbuddy"
dbhost  = '127.0.0.1'
cnx = connect_db(dbuser, dbpasswd, dbhost, dbenviron)
filedict = getfilesfrom_db(cid, cnx)


#grab the files
#all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']

#counter = 0
#for fname in all_files:
stuff = []
for i, v in filedict.iteritems():
  #if counter < 100:
  fname = basedir + "/"  + v
  with open(fname) as f:
    docwords = f.readlines()
    docwords = str(docwords) +"???????" + str(i) + "\n"
    stuff.append(docwords)
    #counter = counter + 1
f = open(outfile ,'w')
for s in stuff:
  f.write(s)
f.close()



