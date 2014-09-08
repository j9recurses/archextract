class CollectionImportMailer < ActionMailer::Base
  default from: "archextract_postmaster@library.berkeley.edu"


  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def import_complete(collection_id, cmd_complete, error=nil)
     @collection = Collection.find(collection_id)
     @greeting = make_greeting(cmd_complete)
    @status_msg=  make_msg(cmd_complete)
    @subject = get_subject(cmd_complete)
    @error = error
    mail(:to => "to@example.org", :subject => @subject)
  end

  def make_msg( cmd_complete)
    status_msg = ''
    if cmd_complete
        status_msg = "You have successfully imported the "+  @collection[:name] + " Collection"
    else
      status_msg = "The collection import failed. Please try again."
    end
    return status_msg
  end

  def make_greeting(cmd_complete)
    if cmd_complete
      greeting = "SUCCESS: The" @collection[:name] + " Collection was successfully imported."
    else
      greeting = "FAILED: Could not import for the " + @collection[:name] + " Collection"
    end
    return greeting
end

  def get_subject(cmd_complete)
    if cmd_complete
      subject = "Success: The" @collection[:name] + " Collection was successfully imported."
    else
      subject  = "Failed: Could not import for the " + @collection[:name] + " Collection"
    end
    return subject
  end
end
