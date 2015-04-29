class ExtractTopicsMailer < ActionMailer::Base
  default from: "archextract_postmaster@library.berkeley.edu"

  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def extract_topics_complete(collection_id, routine_name, cmd_complete, error=nil)
    @collection = Collection.find(collection_id)
    @routine_name = routine_name
    @greeting = make_greeting(cmd_complete)
    @status_msg=  make_msg(cmd_complete)
    @subject = get_subject(cmd_complete)
    @error = error
    mail(:to => "user@example.com", :subject => @subject)
  end

  def make_msg( cmd_complete)
    status_msg = ''
    if cmd_complete
      status_msg = "You have successfully created a topic model for:"
    else
      status_msg = "The topic model you tried to create failed. Please try again. These were your preprocess options: "
    end
    return status_msg
  end

  def make_greeting(cmd_complete)
    if cmd_complete
      greeting = "Success: A Topic Model Has Been Generated For " + @collection[:name] + " Collection: " + @routine_name
    else
      greeting = "FAILED: A topic model could not be generated for  " + @collection[:name] + " Collection: "  + @routine_name
    end
    return greeting
  end

  def get_subject(cmd_complete)
    if cmd_complete
      subject = "Success: A Topic Model Has Been Generated For " + @collection[:name] + " Collection: " + @routine_name
    else
      subject  = "Failed: A topic model could not be generated for " + @collection[:name] + " Collection: "  + @routine_name
    end
    return subject
  end
end
