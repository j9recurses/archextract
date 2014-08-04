#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, re, math, unicodedata
from optparse import OptionParser
import nltk
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.tokenize.punkt import PunktWordTokenizer
from nltk.stem.porter import *
import os

def remove_stopwords(text):
    # remove punctuation
    chars = ['.', '/', "'", '"', '?', '!', '#', '$', '%', '^', '&',
            '*', '(', ')', ' - ', '_', '+' ,'=', '@', ':', '\\', ',',
            ';', '~', '`', '<', '>', '|', '[', ']', '{', '}', '–', '“',
            '»', '«', '°', '’']
    for c in chars:
        text = text.replace(c, ' ')
    text = text.split()
    stopwords = nltk.corpus.stopwords.words('english')
    content = [w for w in text if w.lower().strip() not in stopwords]
    return content

#tokenize the text
def tokenize(text):
    text = ' '.join(text)
    tokens = PunktWordTokenizer().tokenize(text)
    # don't return any single letters
    tokens = [t for t in tokens if len(t) > 1 and not t.isdigit()]
    return tokens

#stem the list
def make_stemmed(word_list):
    stemmer = PorterStemmer()
    stemmed = []
    for w in word_list:
        stemmed.append(stemmer.stem(w))
    return stemmed

#tag the text based on word pos
def make_tagged(word_list, pos_f, remove_ner):
    pos_filter = []
    verb = ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']
    noun = ['NN', 'NP',]
    adj = ['JJ', 'JJR', 'JJS']
    ner = ['NNP', 'NNPS']
    #verb combos
    v_and_n  = verb + noun
    v_and_a = adj+ verb
    v_and_ner = ner + verb
    v_and_n_and_ner = verb + noun + ner
    v_and_n_and_a = verb + noun+ adj
    v_and_ner_and_a = verb + ner + adj
    #noun combos
    n_and_a_and_ner = noun+ adj+ ner
    n_and_ner = noun + ner
    n_and_a = noun+ adj
    a_and_ner =  ner + adj
    all_f = noun + verb + adj + ner
    if 'NN' in pos_f:
        pos_filter =  pos_filter + noun
    if 'VB' in pos_f:
        pos_filter =  pos_filter + verb
    if 'JJ' in pos_f:
        pos_filter =  pos_filter + adj
    if 'NR' in pos_f:
        pos_filter =  pos_filter + ner
    if 'NR' in pos_f:
        pos_list = nltk.pos_tag(word_list)
    #remove the ner terms from the word list
    elif remove_ner == 'yes':
        pos_list = nltk.pos_tag(word_list)
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_n_and_a )]
        pos_list = filtered_pos
    else:
        word_list = map(lambda x:x.lower(), word_list)
        pos_list = nltk.pos_tag(word_list)
    if sorted(pos_filter) == sorted(all_f):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in all_f)]
    elif sorted(pos_filter) == sorted(v_and_n_and_ner):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_n_and_ner)]
    elif sorted(pos_filter) == sorted(v_and_n_and_a):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_n_and_a)]
    elif sorted(pos_filter) == sorted(v_and_ner_and_a):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_ner_and_a)]
    elif sorted(pos_filter) == sorted(v_and_a):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_a)]
    elif sorted(pos_filter) == sorted(v_and_n):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_n)]
    elif sorted(pos_filter) == sorted(v_and_ner):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in v_and_ner)]
    elif sorted(pos_filter) == sorted(n_and_a):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in n_and_a)]
    elif sorted(pos_filter) == sorted(n_and_a_and_ner):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in n_and_a_and_ner)]
    elif sorted(pos_filter) == sorted(n_and_ner):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in n_and_ner)]
    elif sorted(pos_filter) == sorted(a_and_ner):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in a_and_ner)]
    elif sorted(pos_filter) == sorted(adj):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in adj)]
    elif sorted(pos_filter) == sorted(noun):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in noun)]
    elif sorted(pos_filter) == sorted(verb):
        filtered_pos = [tup for tup in pos_list if any(i in tup for i in verb)]
    elif sorted(pos_filter) == sorted(ner):
       filtered_pos = [tup for tup in pos_list if any(i in tup for i in ner)]
    else:
        filtered_pos = "Error: POS filter has invalid input"
    return filtered_pos

def stem_and_tag(word_list, pos, remove_ner):
    tagged = make_tagged(word_list, pos, remove_ner)
    tagged_words = dict(tagged).keys()
    stemmed_tagged_words = make_stemmed(tagged_words)
    return stemmed_tagged_words

def write_results_to_file(result, outdir, f, mycmdopts_fname):
    fsplit = f.split("/")
    f = fsplit.pop()
    fname = outdir  + f + "_" + mycmdopts_fname + ".txt"
    #writer =  open(fname, "w")
    fnew = open(fname,'w')
    fnew.write(f + "\n\n")
    for l in result:
        print l
        fnew.write( l[0] + '\n')
    fnew.close()

####Main######
parser = OptionParser(usage='usage: prog [options] input_file')
parser.add_option('-t', '--tag', dest='tag',
        help='output terms by POS')
parser.add_option('-p', '--POS', dest='pos',
        help='selected POS- can be Nouns, verbs or adj - accepts a list such as NN_VB_JJ_NR')
parser.add_option('-s', '--STEM', dest='stem',
        help='outputs corpus stemmed')
parser.add_option('-r', '--remove_ner', dest='remove_ner',
        help='if tagging, remove NER from results- accepts boolean, T or F')
parser.add_option('-q', '--remove_stopwords', dest='stopwords',
        help='remove stopwords')
parser.add_option('-w', '--write_to_file', dest='wtf',
        help='write tf-idf value for each term in each doc into a file doc')
parser.add_option('-o', '--outdir', dest='outdir_f',
        help='output dir to write output tf-idf files')
parser.add_option('-z', '--removerare', dest='rare',
        help='remove rare words- aka words that only appear once in a collection')
parser.add_option('-f', '--filename', dest='fname',
        help='filename/extension to write preprocessed files as')


#{"stopwords"=>"true", "rarewords"=>"true", "tagged_no_ner"=>"true", "tfidf"=>"true", "stemmed"=>"true", "pos"=>["NN", ""]}



(options, args) = parser.parse_args()
pos = ''
tagger = False
if options.tag:
    tagger = True
if options.pos:
    pos = options.pos
stemmer = False
if options.stem:
   stemmer = True
stopwords = False
if options.stopwords:
   stopwords = True
remove_ner = False
if options.remove_ner:
    remove_ner =  True
results_write_to_f = False
if options.wtf:
    results_write_to_f = True
rare = False
if options.rare:
    rare =  True
mycmdopts_fname = ''
if options.fname:
    mycmdopts_fname = options.fname
outdir = ''
if options.outdir_f:
    outdir = options.outdir_f +"/"
    if not (os.path.isdir(outdir+"/")):
        print "Error: not a valid out dir"
        raise SystemExit
if not args:
    parser.print_help()
    raise SystemExit


basedir = args[0]
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']
if pos:
        pos = pos.split("_")
        pos = map(lambda x:x.upper(), pos)
        pos = sorted(pos)
        pos_str = '-'.join(pos)

counter = 0
for f in all_files:
    mycmdopts = ''
    # local term frequency map
    terms_in_doc = {}
    doc_words    = open(f).read()
    if  stopwords:
        doc_words    = remove_stopwords(doc_words)
    doc_words    = tokenize(doc_words)
    #tag a document
    if tagger and not stemmer:
        doc_tagged = make_tagged(doc_words, pos, remove_ner )
        write_results_to_file(doc_tagged, outdir, f, mycmdopts_fname)
    #stem document
    elif stemmer and not tagger:
        doc_stem = make_stemmed(doc_words)
        print doc_stem
        write_results_to_file(doc_stem, outdir, f, mycmdopts_fname)
     #do both
    elif tagger and stemmer:
        doc_stemmed_and_tagged = stem_and_tag(doc_words, pos, remove_ner)
        write_results_to_file(doc_stemmed_and_tagged, outdir, f, mycmdopts_fname)
    elif stopwords and not tagger and ( not tagger or stemmer):
        write_results_to_file(doc_words, outdir, f, mycmdopts_fname)
    counter = counter + 1
