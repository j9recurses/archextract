class PreprocessesMailer < ActionMailer::Base
  default from: "from@example.com"


  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def preprocess_complete(collection_id, preprocess, cmd_complete)
     @collection = Collection.find(collection_id)
     @greeting = "Preprocess is finished for the " + @collection[:name] + " Collection"
    @preprocess_mail = preprocess
    @status_msg, @stuff =  make_msg(cmd_complete)
    mail(:to => "to@example.org", :subject => "Preprocess Finished for " + @collection[:name] + " Collection ")
  end

  def make_msg( cmd_complete)
    status_msg = ''
    stuff = @preprocess_mail
    if cmd_complete
        status_msg = "You have successfully completed the following Pre-Processes"
    else
      status_msg = "The Pre-Process you selected failed. Please try again. These were your preprocess options: "
    end
    return [status_msg, stuff]
  end

end
