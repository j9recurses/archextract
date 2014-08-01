ExtractTopicRunModel  = Struct.new( :cmd_in, :cmd_out, :extract_topic) do

  def perform
    puts "**extracting topics job***"
    @error = ''
    job_status =  run_pyjob(cmd_in, cmd_out)
    update_status(job_status, extract_topic )
    puts @error
  end


   #runs the python command
  def run_pyjob(cmd_in, cmd_out)
    puts '********'
    puts "in here"
    cmd_complete1 = system(cmd_in)
    if cmd_complete1
      cmd_complete2 = system(cmd_out)
      if cmd_complete2
        return true
      else
         @error = "Error: Mallet Job failed on the 2nd step"
      end
    else
      @error = "Error: Mallet Job failed on the first step"
    end
    return false
  end

  def update_status(job_status, extract_topic )
    extract = ExtractTopic.find(extract_topic[:id])
    if job_status
      extract.update_column(:status, "complete")
    else
      extract.update_column(:status, "failed")
    end
  end

end
