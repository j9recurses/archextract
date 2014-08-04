 class ExtractNerOpts

  def initialize(collection, extractner)
    @collection =  collection
    @extract_ner = extractner
    @error = ''
    @ner_outdir = ''
  end


  def chk_if_ners_exist
    stuff = ExtractNer.where(collection_id: @collection[:id])
    if stuff.size > 0
      return false
    else
      @ner_outdir = Rails.root.join( "public", "src_corpora", @collection[:src_datadir], "extract", "ner").to_s
      @extract_ner[:file_dir]  = @ner_outdir
      @extract_ner[:ner_peeps]  = true
      @extract_ner[:ner_places]  = true
      @extract_ner[:ner_orgs]  = true
      @extract_ner[:ner_dates]  = true
      @extract_ner[:collection_id] = @collection[:id]
      @extract_ner[:status] =  "processing"
      return true,  @extract_ner
    end
  end

  #make the cmd line arguements
  def make_cmdlines
  #make the dirs :
    create_directory_if_not_exists(@ner_outdir)
    #make cmdline args
    inputdir = Rails.root.join( "public/src_corpora" , @collection[:src_datadir], "input").to_s
    ner_scripts_dir = Rails.root.join( "resources", "py_scripts",  "ner_extract" ).to_s
    server_cmd ="java -mx1000m -cp " + ner_scripts_dir + "/stanford-ner-2014-06-16/stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier " + ner_scripts_dir+ "/stanford-ner-2014-06-16/classifiers/english.muc.7class.distsim.crf.ser.gz -port 9000 -outputFormat inlineXML"
    ner_infile_cmds= "python " + ner_scripts_dir + "/get_ner_in_files.py " + "-b " + inputdir + " -o " + @ner_outdir + " -c " + @collection[:src_datadir]  + "-i " + @collection[:id].to_s + " -v development"
    ner_mr_job = "python " + ner_scripts_dir + "/ner_mrjob.py " + @ner_outdir+ "/" + @collection[:src_datadir] + "_ner_infile.txt >> " + @ner_outdir+ "/" + @collection[:src_datadir] + "_ner_processed_ners.txt"
    load_ners_job =  "python " + ner_scripts_dir + "/ner_load_to_db.py  -i " + @ner_outdir+ "/" + @collection[:src_datadir] + "_ner_processed_ners.txt -c " + @collection[:id].to_s + " -v development"
    return server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job
  end



  def create_directory_if_not_exists(directory_name)
    FileUtils::mkdir_p directory_name unless File.exists?(directory_name)
  end

end
