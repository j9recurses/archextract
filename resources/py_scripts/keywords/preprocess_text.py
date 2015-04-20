from nltk.corpus import gutenberg
import random
from random import shuffle
from collections import Counter
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.tokenize.punkt import PunktWordTokenizer
import nltk.tag, nltk.data
from nltk.corpus import wordnet
from nltk.stem.porter import PorterStemmer
import numpy as np
from operator import itemgetter
import csv
import os
import collections
import operator
from collections import OrderedDict
import string
import re


class PreprocessText:

    #function to remove punct.
    def remove_punct(self, text):
      exclude = set(string.punctuation)
      table = string.maketrans("","")
      text = text.translate(table, string.punctuation)
      return text

    #remove stopwords-> A quick way to reduce elminate words that aren't valid key words.
    def removestopwords(self, tokens):
      stopwords = nltk.corpus.stopwords.words('english')
      tokens = [w for w in tokens if w.lower().strip() not in stopwords]
      return tokens

    ##lemmatize the words to reduce dimensionality. Also,option to do lemmatization based on POS.
    #wordnet lemmatizer assumes everything is a noun unless otherwise specified, so we need to give
    #it the wordnet pos if we don't want the default noun lookup.
    def lemmatize(self, tokens, lemmatize_pos):
        def get_wordnet_pos( pos_tag):
            if pos_tag[1].startswith('J'):
                return (pos_tag[0], wordnet.ADJ)
            elif pos_tag[1].startswith('V'):
                return (pos_tag[0], wordnet.VERB)
            elif pos_tag[1].startswith('N'):
                return (pos_tag[0], wordnet.NOUN)
            elif pos_tag[1].startswith('R'):
                return (pos_tag[0], wordnet.ADV)
            else:
                return (pos_tag[0], wordnet.NOUN)
        lemmatizer = WordNetLemmatizer()
        if lemmatize_pos:
            tokens_pos = nltk.tag.pos_tag(tokens)
            filtered_pos =  [(x[0], x[1]) for x in tokens_pos if x[1] in ('NN', 'NNS' 'JJ') and len(x[0]) > 1]
            #print filtered_pos
            tokens_pos_wordnet = [ get_wordnet_pos(token) for token in filtered_pos]
            tokens_lemm = [lemmatizer.lemmatize(token[0], token[1]) for token in tokens_pos_wordnet]
        else:
            tokens_lemm = [lemmatizer.lemmatize(token) for token in tokens]
        return tokens_lemm

    #function that combines above functions in one routine
    #lots of args to specify what preprocessing routine you want to use
    def preprocess_txt(self, text, convertlower=True, nopunk=True, stopwords=True, lemmatize_doc=True, lemmatize_pos=True, stemmed=False):
      #convert to lower
      if convertlower:
        text = text.lower()
      # remove punctuation
      if nopunk:
        text = self.remove_punct(text)
      #tokenize text
      tokens = PunktWordTokenizer().tokenize(text)
      #remove extra whitespaces
      tokens = [token.strip() for token in tokens]
      if stopwords:
        tokens = self.removestopwords(tokens)
      #lemmatize
      if lemmatize_doc:
        tokens = self.lemmatize(tokens,lemmatize_pos)
      #stem
      if stemmed:
        porter = PorterStemmer()
        tokens = [ porter.stem(token) for token in tokens ]
      return tokens
      #combine the tokens back into a string...need to do this for the tfidf vectorizer
      #token_line = " ".join(tokens)
      #return token_line
