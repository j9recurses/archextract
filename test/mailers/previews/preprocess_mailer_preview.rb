class PreprocessesMailerPreview < ActionMailer::Preview

  def preprocess_complete
    collection =  Collection.find(3)
    preprocess  = {"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"}
    PreprocessesMailer. preprocess_complete( collection, preprocess )
  end

end
