ExtractNerRunJob  = Struct.new( :collection, :server_cmd, :ner_infile_cmds, :ner_mr_job, :load_ners_job) do

  def perform
    puts "**extracting ners job***"
    @collection = collection
    @error =
    job_status =  run_pyjob(server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job)
    job_outcome = update_status(job_status, extract_topic )
    puts @error
    ExtractNersMailer.extract_ner_complete( collection[:id], job_outcome , @error).deliver
  end


   #runs the python command
  def run_pyjob(server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job)
    cmd_complete = system(server_cmd)
    cmd_complete1 = system( ner_infile_cmds)
    if cmd_complete1
      cmd_complete2 = system( ner_mr_job)
      if cmd_complete2
        dbcmd_complete = system(load_ners_job)
        if dbcmd_complete
          return true
          puts "sucessfully loaded the ners into the db"
        else
          @error = "Error:  Job failed importing the ner results into the database"
        end
      else
        @error = "Error:  Job failed on the 2nd step, mr job"
      end
    else
      @error = "Error: Job failed on the first step, creating the in-file"
    end
    return false
  end

  def update_status(job_status, extract_topic )
    extract_topic_new = ExtractTopic.find(extract_topic[:id])
    if job_status
      extract_topic_new.update_column(:status, "complete")
    else
      extract_topic_new.update_column(:status, "failed")
    end
  end


end
