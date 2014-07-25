#!/usr/bin/env python
# encoding: utf-8
from __future__ import division
import os
import sys, re, math, unicodedata
from optparse import OptionParser
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.tokenize.punkt import PunktWordTokenizer

"""
File: tfidf.py

Generate the TF-IDF ratings for a collection of documents.

This script will also tokenize the input files to extract words (removes punctuation and puts all in
    lower case), and it will use the NLTK library to lemmatize words (get rid of stemmings)

IMPORTANT:
    A REQUIRED library for this script is NLTK, please make sure it's installed along with the wordnet
    corpus before trying to run this script

Usage:
    - Create a file to hold the paths+names of all your documents (in the example shown: input_files.txt)
    - Make sure you have the full paths to the files listed in the file above each on a separate line
    - For now, the documents are only collections of text, no HTML, XML, RDF, or any other format
    - Simply run this script file with your input file as a single parameter, for example:
            python tfidf.py input_files.txt
    - This script will generate new files, one for each of the input files, with the suffix "_tfidf"
            which contains terms with corresponding tfidf score, each on a separate line

"""

# a list of (words-freq) pairs for each document
global_terms_in_doc = {}
# list to hold occurrences of terms across documents
global_term_freq    = {}
num_docs            = 0
lang        = 'english'
lang_dictionary     = {}
top_k               = -1
supported_langs     = ('english', 'french')

# support for custom language if needed
def loadLanguageLemmas(filePath):
    print('loading language from file: ' + filePath)
    f = open(filePath)
    for line in f:
        words = line.split()
        if words[1] == '=' or words[0] == words[1]:
            continue
        lang_dictionary[words[0]] = words[1]

def remove_diacritic(words):
    for i in range(len(words)):
        w = unicode(words[i], 'ISO-8859-1')
        w = unicodedata.normalize('NFKD', w).encode('ASCII', 'ignore')
        words[i] = w.lower()
    return words

# function to tokenize text, and put words back to their roots
def tokenize(text):

    text = ' '.join(text)
    tokens = PunktWordTokenizer().tokenize(text)

    # lemmatize words. try both noun and verb lemmatizations
    lmtzr = WordNetLemmatizer()
    for i in range(0,len(tokens)):
        #tokens[i] = tokens[i].strip("'")
        if lang != 'english':
            if tokens[i] in lang_dictionary:
                tokens[i] = lang_dictionary[tokens[i]]
        else:
            res = lmtzr.lemmatize(tokens[i])
            if res == tokens[i]:
                tokens[i] = lmtzr.lemmatize(tokens[i], 'v')
            else:
                tokens[i] = res

    # don't return any single letters
    tokens = [t for t in tokens if len(t) > 1 and not t.isdigit()]
    return tokens

def remove_stopwords(text):

    # remove punctuation
    chars = ['.', '/', "'", '"', '?', '!', '#', '$', '%', '^', '&',
            '*', '(', ')', ' - ', '_', '+' ,'=', '@', ':', '\\', ',',
            ';', '~', '`', '<', '>', '|', '[', ']', '{', '}', '–', '“',
            '»', '«', '°', '’']
    for c in chars:
        text = text.replace(c, ' ')

    text = text.split()

    import nltk
    if lang == 'english':
        stopwords = nltk.corpus.stopwords.words('english')
    else:
        stopwords = open(lang + '_stopwords.txt', 'r').read().split()
    content = [w for w in text if w.lower().strip() not in stopwords]
    return content

#returns the tf-idf score for each word and the word
def get_tf_idf_score(f, global_terms_in_doc, num_docs):
    result = []
    # iterate over terms in f, calculate their tf-idf, put in new list
    max_freq = 0;
    for (term,freq) in global_terms_in_doc[f].items():
        if freq > max_freq:
            max_freq = freq
    for (term,freq) in global_terms_in_doc[f].items():
        idf = math.log(float(1 + num_docs) / float(1 + global_term_freq[term]))
        tfidf = float(freq) / float(max_freq) * float(idf)
        result.append([tfidf, term])
    return result

def write_tf_idf_to_file(result, outdir, display_mode, f):
    fsplit = f.split("/")
    f = fsplit.pop()
    writer = open(outdir+ f + '_tfidf', 'w')
    for (tfidf, term) in result[:top_k]:
        if display_mode == 'both':
            writer.write(term + '\t' + str(tfidf) + '\n')
        else:
            writer.write(term + '\n')

# __main__ execution


parser = OptionParser(usage='usage: %prog [options] input_file')
parser.add_option('-l', '--language', dest='language',
        help='language to use in tokenizing and lemmatizing. supported\
                languages: {english, french}', metavar='LANGUAGE')
parser.add_option('-k', '--top-k', dest='top_k',
        help='output only terms with score no less k')
parser.add_option('-m', '--mode', dest='mode',
        help='display mode. can be either "both" or "term"')
parser.add_option('-r', '--remove-rare', dest='removerare',
        help='option to remove parse terms- default is set to false')
parser.add_option('-w', '--write_to_file', dest='wtf',
        help='write tf-idf value for each term in each doc into a file doc')
parser.add_option('-o', '--outdir', dest='outdir_f',
        help='output dir to write output tf-idf files')
parser.add_option('-q', '--remove_stopwords', dest='stopwords',
        help='remove stopwords')
parser.add_option('-s', '--tfidfscore', dest='score',
        help='remove words that fall below a tfidf score')
parser.add_option('-b', '--remove_mean', dest='btm',
        help='remove all words that are below the mean tf-idf score-default is false')
(options, args) = parser.parse_args()

if options.language:
    if options.language not in supported_langs:
        print 'only ', supported_langs, ' are supported in this version.'
        quit()
    if options.language != 'english':
        lang = options.language
        loadLanguageLemmas(options.language + '_lemmas.txt')
if options.top_k:
    top_k = int(options.top_k)
display_mode = 'both'
if options.mode:
    if options.mode == 'both' or options.mode == 'term':
        display_mode = options.mode
    else:
        parser.print_help()
stopwords = False
if options.stopwords:
   stopwords = True
remove_rare = False
score = 0
if options.score
    score = options.score
if options.removerare:
    remove_rare = True
results_write_to_f = False
if options.wtf:
    results_write_to_f = True
outdir = ''
if options.outdir_f:
    outdir = options.outdir_f +"/"
    if (os.path.isdir(outdir+"/")):
        print "printing files to: " + outdir
    else:
        print "Error: not a valid out dir"
        outdir = ''
below_tm = False
if options.btm:
    below_tm = True

if not args:
    parser.print_help()
    quit()

#reader = open(args[0])
#all_files = reader.read().splitlines()

basedir = args[0]
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']
all_files = all_files[:20]

num_docs  = len(all_files)


print('initializing..')
for f in all_files:
    # local term frequency map
    terms_in_doc = {}
    doc_words    = open(f).read().lower()
    #print 'words:\n', doc_words
    if stopwords:
        doc_words    = remove_stopwords(doc_words)
    doc_words    = tokenize(doc_words)
    # increment local count
    for word in doc_words:
        if word in terms_in_doc:
            terms_in_doc[word] += 1
        else:
            terms_in_doc[word]  = 1
    # increment global frequency
    for (word,freq) in terms_in_doc.items():
        if word in global_term_freq:
            global_term_freq[word] += 1
        else:
            global_term_freq[word]  = 1
    global_terms_in_doc[f] = terms_in_doc
    print('working through documents.. ')

#####Check to see if the user wants to exclude words that fall below the mean tf-idf score
if  below_tm :
    median_list = []
    ##iterate through to get the mean tf-idf score
    for f in all_files:
        result = get_tf_idf_score(f, global_terms_in_doc, num_docs)
        #convert list of list into a list of tuples
        tup_list = [tuple(l) for l in result]
        for k in tup_list:
            median_list.append( k[0])
    ##calculate the mean tf-idf score
    mean_tfidf = sum(median_list) / float(len( median_list))
    print "Mean tf-idf score: " + str(mean_tfidf)
    for f in all_files:
        new_result =  []
        result = get_tf_idf_score(f, global_terms_in_doc, num_docs)
        result = sorted(result, reverse=True)
        #if the tf-idf is above the mean, put it into the results list
        for k in result:
            sublist = k[0]
            if sublist > mean_tfidf:
                new_result.append(k)
        #finally, write it to a file if necessary
        if results_write_to_f or len(outdir) > 0:
            write_tf_idf_to_file(new_result, outdir, display_mode, f)

#or if peeps want all the words above a tf-idf score, then do that
else:
    for f in all_files:
        result = get_tf_idf_score(f, global_terms_in_doc, num_docs)
        result = sorted(result, reverse=True)
        ##write them to a file if necessary
        if results_write_to_f  or len(outdir) > 0:
            write_tf_idf_to_file(result, outdir, display_mode, f)

#print mean_tfidf
print('success, with ' + str(num_docs) + ' documents.')
