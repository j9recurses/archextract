from la import larry
import csv
from numpy import *
import numpy as np
from optparse import OptionParser
import mysql.connector
from datetime import datetime
import re

class Parse_Mallet_Out:

  def __init__(self, collection_id, preprocess_id, extract_id, dbenviron):
    self.final_docs = []
    self.final_tops = []
    self.collection_id = collection_id
    self.preprocess_id = preprocess_id
    self.extract_id = extract_id
    self.dbpasswd = "mypass"
    self.dbuser = "myrailsbuddy"
    self.dbhost  = '127.0.0.1'
    self.dbenviron = dbenviron
    self.cnx = self.connect_db(self.dbuser, self.dbpasswd, self.dbhost, self.dbenviron)


  def connect_db(self, dbuser, dbpasswd, dbhost, dbenviron):
    config = {
    'user': dbuser,
    'password': dbpasswd,
    'host': dbhost,
    'database': 'archextract_' + dbenviron,
    'raise_on_warnings': True,
    }
    cnx = mysql.connector.connect(**config)
    return cnx

 #gets intial starting_id for topics
  def get_intial_db_id(self, cnx, idtype,  tblname):
    cursor = cnx.cursor()
    sql = "select max("  + idtype +   ") from " +tblname +";"
    get_max = cursor.execute(sql)
    max_id = cursor.fetchone ()
    max_id = max_id[0]
    if max_id == None:
      max_id = 0
    cursor.close()
    return max_id

#gets the document names from the mallet file
  def get_doc_names(self, doc_infile):
    with open(doc_infile, 'rb') as csvfile:
      spamreader = csv.reader(csvfile, delimiter='\t')
      doc_name_list = []
      for row in spamreader:
        fulldoc =  row[1][5:].strip()
        docpathlist  = fulldoc.split("/")
        docname = docpathlist.pop()
        doc_name_list.append(docname)
      #find the max topic id in the topics table; will use this to start incrementing new ids
      max_id = self.get_intial_db_id(self.cnx, "dcid",  "topic_docs")
      counter =  max_id
      ##make a tuple list of the topics and future db ids
      tup_doc_list = []
      for t in doc_name_list:
        counter = counter + 1
        tup = (counter, t)
        tup_doc_list.append(tup)
    return tup_doc_list

  #gets the topics from the mallet outfile
  def get_topics(self, top_infile):
    topic_name_list = []
    with open(top_infile, 'rb') as csvfile:
      spamreader = csv.reader(csvfile, delimiter='\t')
      for row in spamreader:
        topic_name_list.append( row[2].strip())
      #find the max topic id in the topics table; will use this to start incrementing new ids
      max_id = self.get_intial_db_id(self.cnx, "tid",  "topics")
      counter =  max_id
      ##make a tuple list of the topics and future db ids
      tup_topic_list = []
      for t in topic_name_list:
        counter = counter + 1
        tup = (counter, t)
        tup_topic_list.append(tup)
    return tup_topic_list

  #converts the mallet docs file to a matrix
  def make_doc_model(self, docs_out):
    dtop = genfromtxt(docs_out)
    dtopl   = len(dtop)
    cool =  len(dtop[1])
    new_dtop = dtop[0:dtopl,2: cool ]
    return new_dtop

  def make_ruby_hash(self, dk_list):
    dk_list = str(dk_list)
    dk_list = re.sub(r', \'', ' => \'\'',  dk_list)
    dk_list = re.sub(r'\'\), \(',  '\'\', ',  dk_list)
    dk_list = re.sub(r'\'\)\]',  '\'\'}',  dk_list)
    dk_list = re.sub(r'\[\(',  '{',  dk_list)
    return dk_list

  #gets the topics associated with a document. sorts the docs in desc order with regard to mallet output score
  def get_docs_for_topics(self, topic, topic_name, matrxtype):
    #conver the larry object to a tuple
    ccz =  topic.totuples()
    #sort the tuple
    cv =  sorted(ccz,key=lambda x: x[1], reverse = True)
    dks = []
    dvs = []
    for c in cv:
      dks.append(c[0])
      dvs.append(c[1])
    dks = self.make_ruby_hash(dks)
    if matrxtype ==  "topics":
     self.final_tops.append( [topic_name[0], topic_name[1], self.collection_id, self.preprocess_id, self.extract_id, dks, str(dvs) ])
    elif matrxtype ==  "topic_docs":
      self.final_docs.append([ topic_name[0],topic_name[1], self.collection_id, self.preprocess_id, self.extract_id,  str(dks),  str(dvs)])

  def get_final_docslist(self):
    return self.final_docs

  def get_final_topslist(self):
    return self.final_tops

  def sql_topics(self, list_item, topic_count):
    keys_to_sql_topics  = [ "topic_number", "tid", "name", "collection_id", "preprocess_id", "extract_topic_id", "docs, doc_vals"]
    cols = ', '.join(keys_to_sql_topics)
    vals = ""
    count = 0
    list_item = [topic_count] + list_item
    for v in list_item:
      if count ==  6 or count ==7:
        #v = str(v)
        #v = v.replace("'", "\'\'")
        vals = vals + "'" + str(v) + "',"
        count = count +1
      elif count == 2:
        v = str(v)
        v = "'" + v + "', "
        vals = vals + v
        count = count + 1
      else:
        vals = vals + str(v) + ","
        count = count +1
    vals = vals[:-2]
    insert_sql = "insert into %s (%s) values (" % (matrxtype, cols) +  vals+"');"
    return insert_sql

  def sql_docs(self, list_item):
    keys_to_sql_docs = ["dcid", "name", "collection_id", "preprocess_id", "extract_topic_id", "topics", "topic_vals"]
    cols = ', '.join( keys_to_sql_docs)
    vals = ""
    count = 0
    for v in list_item:
      if count ==  5 or count ==6 or count ==0:
        #v = str(v)
        #v = v.replace("'", "\'\'")
        vals = vals + "'" + str(v) + "',"
        count = count +1
      elif count == 1:
        v = str(v)
        v = "'" + v + "', "
        vals = vals + v
        count = count + 1
      else:
        vals = vals + str(v) + ","
        count = count +1
    vals = vals[:-2]
    insert_sql = "insert into %s (%s) values (" % (matrxtype, cols) +  vals+"');"
    return insert_sql

  #insert everything into the database
  def insert_into_db(self, matrxtype, list_items):
    cursor = self.cnx.cursor()
    topic_count = 0
    for list_item in list_items:
      #convert the lists to strings to insert into the db
      if matrxtype == "topic_docs":
        insert_sql = self.sql_docs(list_item)
      elif matrxtype == "topics":
        insert_sql = self.sql_topics(list_item, topic_count)
      #print "*****"
      #print insert_sql
      cursor.execute( insert_sql)
      self.cnx.commit()
      topic_count = topic_count + 1




####main#######

##cmd opts##############
#EX: of cmd line args: python parse_mallet_out.py -d /home/j9/Desktop/archextract/public/src_corpora/John_Muir/extract/topics/tfidf_btm_lda34/mallet_out -z John_Muir_tfidf_btm_lda_34_doc_topics.txt -t John_Muir_tfidf_btm_lda_34_topic_keys.txt -c 1 -p 4 -e 3 -v development
parser = OptionParser()
parser.add_option('-d', '--dir', dest='mydir',
        help='directory of mallet out files')
parser.add_option('-t', '--topicfile', dest='topicsfile',
        help='mallet topic file')
parser.add_option('-z', '--documentfile', dest='docsfile',
        help='mallet topic file')
parser.add_option('-c', '--collectionid', dest='collection_id',
        help='collection_id of mallet files')
parser.add_option('-p', '--preprocessid', dest='preprocess_id',
        help='preprocess_id of mallet files')
parser.add_option('-e', '--extractid', dest='extract_id',
        help='extract_id of mallet files')
parser.add_option('-v', '--dbenvironment', dest='dbenviron',
        help='database environment to connect to')


(opts, args) = parser.parse_args()

if opts.mydir is None or opts.topicsfile is None or opts.docsfile is None or opts.collection_id is None or opts.preprocess_id is None or opts.extract_id is None or opts.dbenviron is None:
    print "A mandatory option is missing\n"
    print opts
    parser.print_help()
    exit(-1)
else:
  mydir = opts.mydir
  topicsfile = opts.topicsfile
  docsfile = opts.docsfile
  collection_id = int(opts.collection_id)
  preprocess_id = int(opts.preprocess_id)
  extract_id = int(opts.extract_id)
  dbenviron = opts.dbenviron

po = Parse_Mallet_Out(collection_id, preprocess_id, extract_id, dbenviron)

docsf =   mydir + "/" + docsfile
topsf = mydir + "/" + topicsfile


#make a matrix
new_dtop = po.make_doc_model(docsf)
#get the labels
doc_names =  po.get_doc_names(docsf)


topic_names = po.get_topics(topsf)
#set up the larry label
label = [doc_names, topic_names]


#make a larry object by copying the matrix
lar = larry(new_dtop.copy(), [list(l) for l in label])

#get the topics for each doc
matrxtype = "topic_docs"
count1 = 0
for d in lar:
  doc_name = doc_names[count1]
  po.get_docs_for_topics(d, doc_name, matrxtype)
  count1 = count1 + 1
finaldocs = po.get_final_docslist()
cool =  po.insert_into_db(matrxtype, finaldocs)


#transpose the larry object so that you get the topics
translar = lar.T

#get the docs for each topic
matrxtype = "topics"
count = 0
for t in translar:
  topic_name = topic_names[count]
  po.get_docs_for_topics(t, topic_name, matrxtype)
  count = count + 1
  finaltops = po.get_final_topslist()
cool =  po.insert_into_db(matrxtype, finaltops)




