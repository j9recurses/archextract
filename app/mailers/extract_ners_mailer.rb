class ExtractNersMailer < ActionMailer::Base
  default from: "archextract_postmaster@library.berkeley.edu"

  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def extract_ners_complete(collection, job_outcome , error)
    @collection = collection
    @greeting = make_greeting(job_outcome)
    @status_msg=  make_msg(job_outcome)
    @subject = get_subject(job_outcome)
    @error = error
    mail(:to => "user@example.com", :subject => @subject)
  end

  def make_msg( cmd_complete)
    status_msg = ''
    if cmd_complete
      status_msg = "You have successfully generated Named Entities for: " + @ccollection[:name] + "Collection"
    else
      status_msg = "Named Entites for the " + @collection[:name] + "Collection could not be generated. Please try again."
    end
    return status_msg
  end

  def make_greeting(cmd_complete)
    if cmd_complete
      greeting = "SUCCESS: Named Entities have been generated For " + @collection[:name] + " Collection"
    else
      greeting = "FAILED: Named Entities could not be generated for  " + @collection[:name] + " Collection"
    end
    return greeting
  end

  def get_subject(cmd_complete)
    if cmd_complete
      subject = "Success: Named Entities have been generated For " + @collection[:name] + " Collection"
    else
      subject  = "Failed: Named Entities could not be generated for  " + @collection[:name] + " Collection"
    end
    return subject
  end
end
