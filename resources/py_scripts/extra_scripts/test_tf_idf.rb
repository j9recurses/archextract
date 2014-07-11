require 'stanford-core-nlp'

require 'treat'
require 'json'
require_relative './test_stnlp.rb'
require 'gsl'
require 'tf-idf-similarity'
require 'matrix'
require 'tf_idf'



class Tfidf_for_Archive
  #turns a file_dir into a collection- one giant chunk of text
  def make_collection(file_dir)
    c = collection(file_dir)
    return c
  end

  def treat_get_tf_idf(file_dir)
    #corpus = corpus.values
    #corpus is a list of lists- need to convert it into a single array
    #corpus = corpus.flatten
    corpus = make_collection(file_dir)
    corpus.apply(:chunk, :segment, :tokenize, :keywords)
    print corpus
  end

  def get_tf_idf_bad(corpus)
    tf_corpus = Array.new()
    corpus = corpus.values
    ##corpus is a list of lists- need to convert it into a single array
    corpus = corpus.flatten
    corpus.each do | c|
      tf_corpus << TfIdfSimilarity::Document.new(c)
    end
    model = TfIdfSimilarity::TfIdfModel.new(tf_corpus, :library => :gsl)
    print model
  end

  def get_tf_idf_per_doc(file_dir)
    wasGood = system( 'python /home/j9/Desktop/bancroft/tf_idf_test/tfidf.py -l english -b True -o ' +tf_idf_outdir + 'john_muircollection_file_list.txt')
    return was_good
  end


  base_dir = '/home/j9/Desktop/bancroft/john_muir/data/plaintxt'
  tf =  Tfidf_for_Archive.new()
  np =  NLP_Base.new()


  file_list = np.get_files(base_dir)
  corpus = np.load_files(file_list)
  model = tf.get_tf_idf(corpus)
