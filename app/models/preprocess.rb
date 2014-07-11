class Preprocess < ActiveRecord::Base
  belongs_to :collection

  #{"stopwords"=>"true", "rarewords"=>"true", "tagged_no_ner"=>"true", "tfidf"=>"true", "stemmed"=>"true", "pos"=>["NN", ""]}


end
