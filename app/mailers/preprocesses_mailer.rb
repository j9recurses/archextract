class PreprocessesMailer < ActionMailer::Base
  default from: "archextract_postmaster@library.berkeley.edu"


  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def preprocess_complete(collection_id, routine_name, cmd_complete, error=nil)
     @collection = Collection.find(collection_id)
     @routine_name = routine_name
     @greeting = make_greeting(cmd_complete)
    @status_msg=  make_msg(cmd_complete)
    @subject = get_subject(cmd_complete)
    @error = error
    mail(:to => "to@example.org", :subject => @subject)
  end

  def make_msg( cmd_complete)
    status_msg = ''
    if cmd_complete
        status_msg = "You have successfully completed the following Pre-Processes. These where your preprocessing options:"
    else
      status_msg = "The Pre-Process you selected failed. Please try again. These were your preprocess options: "
    end
    return status_msg
  end

  def make_greeting(cmd_complete)
    if cmd_complete
      greeting = "SUCCESS: Pre-Process is finished for the " + @collection[:name] + " Collection"
    else
      greeting = "FAILED: Pre-Process is finished for the " + @collection[:name] + " Collection"
    end
    return greeting
end

  def get_subject(cmd_complete)
    if cmd_complete
      subject = "Success: Preprocess Finished for " + @collection[:name] + " Collection "
    else
      subject  = "Failed: Preprocess Finished for " + @collection[:name] + " Collection "
    end
    return subject
  end
end
