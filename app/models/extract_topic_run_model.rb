ExtractTopicRunModel  = Struct.new( :cmd_in, :cmd_out, :dbcmd,  :extract_topic, :collection) do

  def perform
    puts "**extracting topics job***"
    @error = ''
    job_status =  run_pyjob(cmd_in, cmd_out, dbcmd)
    job_outcome = update_status(job_status, extract_topic )
    puts "******job status******"
    puts job_outcome
    puts @error
    ExtractTopicsMailer.extract_topics_complete( collection[:id], extract_topic[:routine_name], job_outcome , @error).deliver
  end


   #runs the python command
  def run_pyjob(cmd_in, cmd_out, dbcmd)
    puts cmd_in
    cmd_complete1 = system(cmd_in)
    if cmd_complete1
      cmd_complete2 = system(cmd_out)
      if cmd_complete2
        puts "************"
        puts dbcmd
        dbcmd_complete = system(dbcmd)
        if dbcmd_complete
          puts "sucessfully loaded mallet into the db"
        else
          @error = "Error:  Job failed importing results into the database"
        end
      else
        @error = "Error: Mallet Job failed on the 2nd step"
      end
    else
      @error = "Error: Mallet Job failed on the first step"
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
