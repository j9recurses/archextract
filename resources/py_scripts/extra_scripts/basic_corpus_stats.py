#!/usr/bin/python
from __future__ import division
import nltk 
from nltk.book import *
from operator import itemgetter
from nltk.corpus import stopwords
import string
import re

class basic_corpus_stats:

	def parse_args(self, *args):
		if len(args) == 0:
			print "Error: Please enter some args"
			print "Args are: most_frequentwords( corpus, sort_val, custom_stop_list, no_std_stop_list, word_length)"
			print "most_frequentwords(text1, 20, ['whale', 'stale, 'duck', 'goose'], False, 9)"
			print "corpus = text to use; needs to be a list"
			print "sort_val =  how many words to return. A int value"
			print "custom_stop_list = list of custom stop words"
			print "no_std_stop_list =  Use the standard stop word list, defaut is true, accepts Boolean false"
			print "word_length= only evaluate words at a given length, takes an int value, "
			print "to use word_lenght, you must put a place holder for the sort value, so that:"
			print "most_frequentwords(text1, 0, 12) --> this would return all words with a length greater than 12"
			print "most_frequentwords(text1, 20, 12) --> this would return the top 20 most frequently used words with a word length greater than 12"
			return "Error; check syntax"
		text = None
		sort_val = None
		custom_stoplist = None
		no_stop_list = None 
		word_len =  None
		if len(args) > 0:
			text =  args[0]
			if type(args[1]) == int: 
				sort_val= args[1]
			elif type(args[1]) == list: 
				custom_stoplist= args[1]
				sort_val =  None
			elif type(args[1]) == bool: 
				no_stop_list =  args[1]
				sort_val =   None
			else:
				sort_val =  None
			if len(args) > 2:
				if type(args[2]) == list: 
					custom_stoplist =  args[2]
				elif type(args[2]) == bool: 
					no_stop_list =  args[2]
					custom_stoplist =   None
				elif type(args[2]) == int: 
					word_len =   args[2]
					custom_stoplist =  None
				else:
					custom_stoplist =  None
			if len(args) > 3: 
				if type(args[3]) == bool: 
					no_stop_list =  args[3]
				elif type(args[3]) == int:
					word_len =   args[3]
					no_stop_list =  None
				else: 
					no_stop_list =  None
			if len(args) > 4:
				word_len =  args[4]
		final_args = {}
		final_args['text'] = text
		final_args['sort_val'] = sort_val
		final_args['custom_stoplist'] = custom_stoplist
		final_args['no_stop_list'] = no_stop_list
		final_args['word_len'] = word_len
		return final_args


	#search the text for a given word- see a given word in context
	#text1.concordance("monstrous")
	#similar shows what words appear in a similar range of contexts? 
	#text1.similar("monstrous")

	#plots a dispersion plot of a list of words
	def get_dispersion_plot_list(self, text, word_list):
		text.dispersion_plot(word_list)

	#plots a dispersion plot of a list of words
	def get_dispersion_plot_list(self, text, word_dict):
		word_list = word_list.keys()
		text.dispersion_plot(word_list)

	#graphical plot of the frequency distribution
	def get_fdist_plot(self, text):
		fdist = FreqDist(text)
		fdist.plot()

	#find the richness of the text- aka how much words/diversity is there
	def lexical_diversity(self, my_text_data):
		word_count = len(my_text_data)
		vocab_size = len(set(my_text_data))
		diversity_score = word_count / vocab_size
		return diversity_score

	#takes a singular noun and generates a plural form
	def generate_plurals(self, word):
   		if word.endswith('y'):
        	return word[:-1] + 'ies'
   	 	elif word[-1] in 'sx' or word[-2:] in ['sh', 'ch']:
       	 	return word + 'es'
    	elif word.endswith('an'):
       		return word[:-2] + 'en'
    	else:
        	return word + 's'

	#compute what percentage of the text is taken up by a specific word
	#def word_doc_percentage(self, count, total):
		#return 100 * count / total


	#findunusual or mis-spelt words in a text corpuS
	def unusual_words(text):
    	text_vocab = set(w.lower() for w in text if w.isalpha())
    	english_vocab = set(w.lower() for w in nltk.corpus.words.words())
   	 	unusual = text_vocab.difference(english_vocab)
    	return sorted(unusual)

    #compute what fraction of words in a text are not in the stopwords list:
    def content_fraction(text):
 		stopwords = nltk.corpus.stopwords.words('english')
		content = [w for w in text if w.lower() not in stopwords]
		return len(content) / len(text)	


###3main
#usage for the the above functions
#fdist1_longlistset = find_word_len_list(15, text1)
#print fdist1_longlistset
#fdist1_longdict = find_word_len_dict(12, text1, 10)
#print fdist1_longdict
bcs = basic_corpus_stats()
myargs = bcs.parse_args(text1, 20, ['harpooneer', 'harpooneers'], True, 10)
print myargs
fdist1_sorted = bcs.most_frequentwords(myargs)
print fdist1_sorted

#get_dispersion_plot_list(self, text1, fdist1_sorted)
#bcs.get_fdist_plot(text1)

#dist = FreqDist(text1)
#cool = fdist.tabulate()
#print cool
#to do-> fix up lists functions
#also- it would be cool to use jaquard to get groups