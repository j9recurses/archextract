import json
from pprint import pprint
import operator
import mysql.connector
from optparse import OptionParser

##script to import ners into the db.
#make a cmd line arg acceptor. Need to put the following options
#dbenviron
#file in

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



parser = OptionParser()
parser.add_option('-i', '--infile', dest='infile',
        help='infile')
parser.add_option('-v', '--dbenviron', dest='dbenviron',
        help='dbenviron')
parser.add_option('-c', '--collection_id', dest='collection_id',
        help='collection id')
parser.add_option('-n', '--ner_extract_id', dest='ner_extract_id',
        help='ner extract id')
(opts, args) = parser.parse_args()

if  opts.infile is None or opts.dbenviron is None or opts.collection_id is None or opts.ner_extract_id  is None:
  print "A mandatory option is missing\n"
  print opts
  parser.print_help()
  exit(-1)
else:
  #mydir = opts.mydir
  infile  = opts.infile
  dbenviron = opts.dbenviron
  collection_id = opts.collection_id
  ner_extract_id = opts.ner_extract_id

dbpasswd = "mypass"
dbuser = "myrailsbuddy"
dbhost  = '127.0.0.1'
cnx = connect_db(dbuser, dbpasswd, dbhost, dbenviron)


with open(infile) as f:
      docwords = f.readlines()
for d in docwords:
  newd =  d.split("\t")
  myner = newd.pop()
  data = eval(myner)
  if len(data) == 0:
    next
  mtype =  data[0]
  ner = data[1]
  if ner == '':
    next
  ner = ner.replace("'", "")
  ner = ner.replace("\\", "")
  files =  data[2]
  files = str(files)
  files = files.replace("'", "")
  #files = files.replace("',", "\'\',")
  #files = files.replace("']", "\'\']"
  nercount = data[3]
  stuff1 = "INSERT INTO ners "
  stuff2 = "(nertype, name, docs, count, collection_id, extract_ner_id) "
  stuff3 = "VALUES ( " + "'" + mtype+ "','" + ner +"','"+  files+"', "+ str(nercount) +"," + collection_id + "," + str(ner_extract_id) + ");"
  inserts = stuff1+ stuff2+stuff3
  print inserts
  cursor = cnx.cursor()
  cursor.execute(inserts)
  cnx.commit()
  cursor.close()
