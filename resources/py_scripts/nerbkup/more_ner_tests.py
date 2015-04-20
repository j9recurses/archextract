# -*- coding: utf-8 -*-
#!/usr/bin/python

import os
import nltk
import pandas
import csv

def import_file(import_file):
  i_f = open( import_file, 'r' )
  reader = csv.reader( i_f, delimiter = ' ' )

#  "returns named entity chunks in a given text"
def parts_of_speech(corpus):
  sentences = nltk.sent_tokenize(corpus)
  tokenized = [nltk.word_tokenize(sentence) for sentence in sentences]
  pos_tags  = [nltk.pos_tag(sentence) for sentence in tokenized]
  return nltk.batch_ne_chunk(pos_tags, binary=True)

#"recursively traverses an nltk.tree.Tree to find named entities"


def traverse(tree):
  entity_names = []
  if hasattr(tree, 'node') and tree.node:
    if tree.node == 'NE':
      entity_names.append(' '.join([child[0] for child in tree]))
    else:
      for child in tree:
        entity_names.extend(traverse(child))
  return entity_names

#"given list of tagged parts of speech, returns unique named entities"
def find_entities(chunks):
  named_entities = []
  for chunk in chunks:
    entities = sorted(list(set([word for tree in chunk for word in traverse(tree)])))
    for e in entities:
      if e not in named_entities:
        named_entities.append(e)
  return named_entities



#to use
basedir = "/home/j9/Desktop/bancroft/john_muir/data/plaintxt"
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']


for f in all_files:
  df        = open(f).read()
  print "##############################"
  print f
  print "##############################"
  #f_text =import_file(f)
  chunks = parts_of_speech(df)
  ner_chunks = find_entities(chunks)
  print ner_chunks


  #
  #cool =  tagger.get_entities(doc_words)
  #print cool



#entity_chunks  = parts_of_speech(text)
#find_entities(entity_chunks)

