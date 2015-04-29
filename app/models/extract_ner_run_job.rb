ExtractNerRunJob  = Struct.new( :server_cmd, :ner_infile_cmds, :ner_mr_job, :load_ners_job, :resolve_ners_job, :collection, :extract_ner) do

  def perform
    puts "**extracting ners job***"
    @collection = collection
    @error = ''
    job_status =  run_pyjob(server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job, resolve_ners_job)
    puts "******made it here!!****"
    job_outcome = update_status(job_status, extract_ner )
    puts @error
    ExtractNersMailer.extract_ners_complete( @collection, job_outcome , @error).deliver
  end

   #runs the python command
  def run_pyjob(server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job, resolve_ners_job)
    #puts "running server command"
    #puts server_cmd
   # cmd_complete = system(server_cmd)
    puts ner_infile_cmds
    cmd_complete1 = system( ner_infile_cmds)
    if cmd_complete1
      puts ner_mr_job
      cmd_complete2 = system( ner_mr_job)
      if cmd_complete2
        puts load_ners_job
        dbcmd_complete = system(load_ners_job)
        if dbcmd_complete
          puts "sucessfully loaded the ners into the db"
          print resolve_ners_job
          dbcmd_complete = system(resolve_ners_job)
          if dbcmd_complete
            puts "sucessfully resolved_ners"
            return "job succeeded"
          else
            @error = "Error:  Job failed resolving ners"
          end
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

  def update_status(job_status, extract_ner )
    extract_ner_new = ExtractNer.find(extract_ner[:id])
    if job_status
      extract_ner_new.update_column(:status, "complete")
    else
      extract_ner_new.update_column(:status, "failed")
    end
  end




end
