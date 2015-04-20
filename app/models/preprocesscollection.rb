#need to start up: rake jobs:work

Preprocesscollection  = Struct.new( :preprocess, :collection_id, :preprocessdb) do
  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},
#python /home/j9/Desktop/archextract/resources/py_scripts/tfidf/tfidf.py /home/j9/Desktop/archextract/public/src_corpora/John_Muir_Letters/input  -l english -b True -o /home/j9/Desktop/test_tfidf -f tfidf_btm
#python /home/j9/Desktop/archextract/resources/py_scripts/tfidf/tfidf.py /home/j9/Desktop/archextract/public/src_corpora/John_Muir_Letters/input  -l english -s .5 -o /home/j9/Desktop/test_tfidf -f score_05


  def perform
    puts "**processing pre-process job***"
    @preprocess = preprocess
    @preprocessdb =preprocessdb
    @collection_id = collection_id
    @collection = Collection.find(@collection_id)
    @inputdir = Rails.root.join( "public/src_corpora",  @collection.src_datadir, "input")
    @inputpy_dir =  Rails.root.join( "resources/py_scripts")
    @cmdline_arg_st_sttg = "python " + @inputpy_dir.to_s + '/stemmer_and_tagger/stemmer_and_tagger.py ' + @inputdir.to_s
    @cmd_which= ""
    @cmdline_arg_st_tfidf= "python " + @inputpy_dir.to_s + "/tfidf/tfidf.py " + @inputdir.to_s + " -l english"
    @outdir = Array.new()
    @error = ""
    puts "****params***"
    puts @preprocess
    get_preprocess_stem_tag_cmd
  end


  def get_preprocess_stem_tag_cmd
    new_pos = get_pos
    puts "*********here***"
    no_ner
    stemmed
    stopwords
    rarewords
    tfidf
    collection_outdir_and_filout
    unless @error.length  > 1
      cmd_complete =  run_pyjob
      puts "*********"
      puts cmd_complete
      update_status(cmd_complete)
      PreprocessesMailer.preprocess_complete(@collection_id, @preprocessdb[:routine_name ], cmd_complete).deliver
    else
       PreprocessesMailer.preprocess_complete(@collection_id, @preprocessdb[:routine_name ], cmd_complete, @error).deliver
    end
  end

  def get_pos
    if @preprocess[:pos].size > 1
      new_pos = @preprocess[:pos].join('_')
      new_pos = new_pos.chomp("_")
      @cmdline_arg_st_sttg =  @cmdline_arg_st_sttg + " -t True -p " + new_pos
      @preprocess[:pos] = new_pos
      @outdir << "tagged"
      @outdir << new_pos
      return new_pos
    end
  end

  def no_ner
    if @preprocess[:tagged_no_ner]
      @cmdline_arg_st_sttg = @cmdline_arg_st_sttg + " -r True"
      @outdir << "no_ner"
    end
  end

  def stemmed
    if @preprocess[:stemmed]
      @cmdline_arg_st_sttg =  @cmdline_arg_st_sttg + " -s True"
      @outdir << "stemmed"
    end
  end

  def stopwords
    if @preprocess[:stopwords]
      unless @preprocess[:tfidf_btm]  or @preprocess[:tfidf_score] != ""
        @cmdline_arg_st_sttg =  @cmdline_arg_st_sttg + " -q True"
        puts "****stopwords*****"
        puts @cmdline_arg_st_sttg
        @outdir << "stopwords"
      else
       @cmdline_arg_st_tfidf =  @cmdline_arg_st_tfidf + " -q True"
       puts "****stopwords tfidf*****"
        puts @cmdline_arg_st_tfidf
       @outdir << "stopwords"
      end
    end
  end

  def rarewords
    if @preprocess[:rarewords]
      @cmdline_arg_st_sttg =  @cmdline_arg_st_sttg + " -z True"
      @outdir << "rare_words"
    end
  end

  def tfidf
     if @preprocess[:tfidf_btm]
        @outdir << "tfidf_btm"
        @cmd_which = "tfidf"
        @cmdline_arg_st_tfidf = @cmdline_arg_st_tfidf + " -b True"
     elsif @preprocess[:tfidf_score] != ""
      @cmd_which = "tfidf"
       tfscore_new = @preprocess[:tfidf_score].sub('.', 'p')
       @outdir << "tfidf_score_" + tfscore_new
       @cmdline_arg_st_tfidf = @cmdline_arg_st_tfidf + " -s " +  @preprocess[:tfidf_score]
     end
     puts  @cmdline_arg_st_tfidf
  end

  #sets file and outdirs for pre-process
  def collection_outdir_and_filout
    outdir_opts = @outdir.join("_")
    outdir_base = Rails.root.join( "public/src_corpora", @collection.src_datadir, "preprocess")
    outdir = Rails.root.join( "public/src_corpora", @collection.src_datadir, "preprocess", outdir_opts)
    dirchk = self.check_and_make_dir(outdir_base, outdir)
    if dirchk
      puts '****cmd****which****'
      puts @cmd_which
      if @cmd_which == "tfidf"
        @cmdline_arg_st_tfidf = @cmdline_arg_st_tfidf  + " -o " + outdir.to_s
        @cmdline_arg_st_tfidf =  @cmdline_arg_st_tfidf + " -f " + outdir_opts.to_s
        puts  @cmdline_arg_st_tfidf
      else
        @cmdline_arg_st_sttg = @cmdline_arg_st_sttg + " -o " + outdir.to_s
        @cmdline_arg_st_sttg = @cmdline_arg_st_sttg + " -f " + outdir_opts.to_s
      end
    end
  end

  #checks and makes a dir for a  collection
  def check_and_make_dir(mydir_base, mydir)
    if FileTest::directory?(mydir)
      puts "error here"
      @error = "Error: A directory for the collection you entered already exists- Please try again"
      return false
    else
      if FileTest::directory?(mydir_base)
        Dir::mkdir(mydir)
      else
        @error =  "Error: base file dir does not exist"
        return false
      end
    end
    return true
  end


  #runs the python command
  def run_pyjob
    puts '********'
    puts "in here"
     if @cmd_which == "tfidf"
      puts "inside tfidf"
      cmd_complete = system(@cmdline_arg_st_tfidf)
    else
      puts "inside other"
      puts @cmdline_arg_st_sttg
      cmd_complete = system(@cmdline_arg_st_sttg)
    end
    return cmd_complete
  end

  def update_status(cmd_complete)
    @new_preprocessdb = Preprocess.find(@preprocessdb[:id])
    if cmd_complete
      @new_preprocessdb.update_column(:status, "complete")
    else
      @new_preprocessdb.update_column(:status, "failed")
    end
  end
end
