#need to start up: rake jobs:work

Preprocesscollection  = Struct.new( :preprocess, :collection_id, :preprocessdb) do
  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  #def initialize(preprocess, collection_id)
  def perform
    puts "in here"
    @preprocess = preprocess
    @preprocessdb =preprocessdb
    @collection_id = collection_id
    @collection = Collection.find(@collection_id)
    @inputdir = Rails.root.join( "public/src_corpora",  @collection.src_datadir, "input")
    @inputpy_dir =  Rails.root.join( "resources/py_scripts")
    @cmdline_arg_st = "python " + @inputpy_dir.to_s + '/stemmer_and_tagger/stemmer_and_tagger.py ' + @inputdir.to_s
    @outdir = Array.new()
    @error = ''
    get_preprocess_stem_tag_cmd
  end


  def get_preprocess_stem_tag_cmd
    new_pos = get_pos
    no_ner
    stemmed
    stopwords
    rarewords
    collection_outdir_and_filout
    unless @error.length  > 1
      cmd_complete =  run_pyjob
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
      @cmdline_arg_st =  @cmdline_arg_st + " -t True -p " + new_pos
      @preprocess[:pos] = new_pos
      @outdir << "tagged"
      @outdir << new_pos
      return new_pos
    end
  end

  def no_ner
    if @preprocess[:tagged_no_ner]
      @cmdline_arg_st = @cmdline_arg_st + " -r True"
      @outdir << "no_ner"
    end
  end

  def stemmed
    if @preprocess[:stemmed]
      @cmdline_arg_st =  @cmdline_arg_st + " -s True"
      @outdir << "stemmed"
    end
  end

  def stopwords
    if @preprocess[:stopwords]
      @cmdline_arg_st =  @cmdline_arg_st + " -q True"
      @outdir << "stopwords"
    end
  end

  def rarewords
    if @preprocess[:rarewords]
      @cmdline_arg_st =  @cmdline_arg_st + " -z True"
      @outdir << "rare_words"
    end
  end

  #sets file and outdirs for pre-process
  def collection_outdir_and_filout
    outdir_opts = @outdir.join("_")
    outdir_base = Rails.root.join( "public/src_corpora", @collection.src_datadir, "preprocess")
    outdir = Rails.root.join( "public/src_corpora", @collection.src_datadir, "preprocess", outdir_opts)
    dirchk = self.check_and_make_dir(outdir_base, outdir)
    if dirchk
      @cmdline_arg_st = @cmdline_arg_st + " -o " + outdir.to_s
      @cmdline_arg_st = @cmdline_arg_st + " -f " + outdir_opts.to_s
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
        puts "second error"
        @error =  "Error: base file dir does not exist"
        return false
      end
    end
    return true
  end

  #runs the python command
  def run_pyjob
    cmd_complete = system(@cmdline_arg_st)
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
