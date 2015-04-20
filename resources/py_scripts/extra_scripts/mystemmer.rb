require 'stanford-core-nlp'

require 'treat'
require 'json'
require_relative './test_stnlp.rb'
require 'gsl'
require 'tf-idf-similarity'
require 'matrix'
require 'tf_idf'

##classs to stem words in corpus documents and write them to a file
class MyStemmer < NLP_Base

  def make_section(text)
    text = text.to_s
    sect = section text
    return sect
  end

  ##tag the words by POS
  def make_tagged(sect)
    sect.apply :tokenize => :ptb, :tag => :stanford
    return sect
  end

  #stem the words
  def make_stemmed(sect)
    sect.apply  :tokenize => :ptb, :stem => :porter
    return sect
  end

  #tag and stemm the words
  def make_stemmed_and_tagged(sect)
    sect.apply :tokenize => :ptb, :stem => :porter, :tag => :stanford
    return sect
  end
  ##transfer the sentence object to an iterable object
  def make_word_array(sect)
    word_arry = Array.new()
    sect.each do | para|
      puts para
      para.each do |sent|
        puts sent
      end
    end
  end
end
##main####
base_dir = '/home/j9/Desktop/bancroft/john_muir/data/plaintxt'

np =  MyStemmer.new()

#create the corpus from a file dir
file_list = np.get_files(base_dir)
corpus = np.load_files(file_list)


corpus.each do | c,v |
  cool = np.make_stemmed_and_tagged(v)
end
