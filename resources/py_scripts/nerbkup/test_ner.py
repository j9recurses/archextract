#!/usr/bin/env python
# encoding: utf-8
from __future__ import division
import os
import ner


##need to fire up the ner server before running the program
#java -mx1000m -cp stanford-ner-2014-06-16/stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier stanford-ner-2014-06-16/classifiers/english.muc.7class.distsim.crf.ser.gz -port 9000 -outputFormat inlineXML

#find peeps
def find_peep_in_cnt_dict(peep):
  if peep in person_dict_cnt:
    current_ct = person_dict_cnt[peep]
    person_dict_cnt[peep] =  current_ct + 1
  else:
    person_dict_cnt[peep] = 1

def find_peep_in_file_dict(peep, filename):
  if peep in person_dict_file:
    current_file_list = person_dict_file[peep]
    if filename not in current_file_list:
      current_file_list.append(filename)
      person_dict_file[peep] = current_file_list
  else:
    person_dict_file[peep] = [filename]

def get_peeps(nertxt_dict, filename):
  if "PERSON" in nertxt_dict:
     peeps = nertxt_dict["PERSON"]
     for p in peeps:
        find_peep_in_cnt_dict(p)
        find_peep_in_file_dict(p, filename)

####orgs
def find_org_in_cnt_dict(org):
  if org in org_dict_cnt:
    current_ct = org_dict_cnt[org]
    org_dict_cnt[org] =  current_ct + 1
  else:
    org_dict_cnt[org] = 1

def find_org_in_file_dict(org, filename):
  if org in org_dict_file:
    current_file_list = org_dict_file[org]
    if filename not in current_file_list:
      current_file_list.append(filename)
      org_dict_file[org] = current_file_list
  else:
    org_dict_file[org] = [filename]

def get_orgs(nertxt_dict, filename):
  if "ORGANIZATION" in nertxt_dict:
     orgs = nertxt_dict["ORGANIZATION"]
     for p in orgs:
        find_org_in_cnt_dict(p)
        find_org_in_file_dict(p, filename)

########places######


######main######


basedir = "/home/j9/Desktop/bancroft/john_muir/data/plaintxt"

#grab the files
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']

tagger = ner.SocketNER(host='localhost', port=9000)
count = 0

loc_dict_cnt = {}
org_dict_cnt = {}
person_dict_cnt = {}
date_dict_cnt  = {}
loc_dict_file = {}
org_dict_file = {}
person_dict_file = {}
date_dict_file  = {}

for f in all_files:
  if count < 100:
    print "##############################"
    print f
    print "##############################"
    doc_words    = open(f).read()
    cool =  tagger.get_entities(doc_words)
    count = count + 1
    get_peeps(cool, f)
    get_orgs(cool, f)
    print org_dict_cnt
   # org_dict_file
    #print person_dict_cnt
    #print person_dict_file
