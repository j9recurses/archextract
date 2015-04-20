class CollectionImportMailer < ActionMailer::Base
  default from: "archextract_postmaster@library.berkeley.edu"


  #to use: #PreprocessesMailer.preprocess_complete(c,p, cc)
  def import_complete(collection, success=nil, failed=nil, error=nil)
     @subject = get_subject(collection)
     @greeting = get_subject(collection)
    @status_msg=  make_msg(collection, success, failed, error)
    mail(:to => "to@example.org", :subject => @subject)
  end

  def make_msg(collection, success, failed, error)
    status_msg = ''
    puts error
    if error != 0
       status_msg = "ArchExtract could not import the "+ collection[:name]  + ". Please try again. </br> "
    else
      status_msg = "ArchExtract successfully imported the "+  collection[:name] + " Collection. </br>"
      unless success.nil? or success == ''
        status_msg = status_msg + "ArchExtract imported the following documents:</br>" + success + "</br>"
      end
      unless failed.nil? or failed == ''
        status_msg = status_msg + "ArchExtract could not import the following documents: " + failed
      end
    end
    return status_msg
  end



  def get_subject(collection)
      subject = "The " + collection[:name] + " Collection has been imported."
    return subject
  end
end
