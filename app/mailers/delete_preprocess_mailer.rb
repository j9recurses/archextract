class DeletePreprocessMailer < ActionMailer::Base
  default from: "from@example.com"

  def preprocess_delete(collection_id, preprocess, cmd_complete)
    puts cmd_complete
    @collection = Collection.find(collection_id)
    @greeting = make_greeting(cmd_complete)
    @preprocess_mail = preprocess
    @stuff = @preprocess_mail[:routine_name].to_s
    @status_msg =  make_msg(cmd_complete)
    @subject = get_subject(cmd_complete)
    mail(:to => "to@example.org", :subject => @subject)
  end

  def make_msg( cmd_complete)
    status_msg = ''
    stuff = @preprocess_mail
    if cmd_complete
        status_msg = "You have successfully deleted the following preprocess: "
    else
      status_msg = "Error: Could not delete the following pre-process:"
    end
    return status_msg
  end

  def make_greeting(cmd_complete)
    if cmd_complete
      greeting = "SUCCESS: " + @collection[:name] + " Collection Pre-Process Was Deleted"
    else
      greeting = "FAILED: " + @collection[:name] + " Collection Pre-Process Could Not Be Deleted"
    end
    return greeting
end

  def get_subject(cmd_complete)
    if cmd_complete
      subject = "Success: " + @collection[:name] + " Collection Pre-Process Was Deleted"
    else
      subject  = "Failed: " + @collection[:name] + " Collection Pre-Process Could Not Be Deleted"
    end
    return subject
  end
end
