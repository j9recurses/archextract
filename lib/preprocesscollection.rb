

#class Preprocesscollection <  Struct.new( :preprocess, :collection_id) do

 Preprocesscollection  = Struct.new( :preprocess, :collection_id) do
 # attr_accessor :preprocess, :cmdline_arg_st, :collection_id

  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  #def initialize(preprocess, collection_id)
  def perform
    puts "in here"
    @preprocess = preprocess
    @collection_id = collection_id
    @collection = Collection.find(@collection_id)
    @inputdir = Rails.root.join( "public/src_corpora",  @collection.src_datadir, "input")
    @inputpy_dir =  Rails.root.join( "public/py_scripts")
    @cmdline_arg_st = "python " + @inputpy_dir.to_s + '/stemmer_and_tagger/stemmer_and_tagger.py ' + @inputdir.to_s
    @outdir = Array.new()
    get_preprocess_stem_tag_cmd
  end
  #

  def get_preprocess_stem_tag_cmd
    get_pos
    no_ner
    stemmed
    stopwords
    rarewords
    collection_outdir_and_filout
  end

  def get_pos
    if @preprocess[:pos].size > 0
      new_pos = @preprocess[:pos].join('_')
      new_pos = new_pos.chomp("_")
      puts new_pos
      @cmdline_arg_st =  @cmdline_arg_st + " -t True -p " + new_pos
      @preprocess[:pos] = new_pos
      @outdir << "tagged"
      @outdir << new_pos
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
    #dirchk, error = self.check_and_make_dir(outdir_base, outdir)
    dirchk =  true
    if dirchk
      @cmdline_arg_st = @cmdline_arg_st + " -o " + outdir.to_s
      @cmdline_arg_st = @cmdline_arg_st + " -f " + outdir_opts.to_s
    end
  end

  #checks and makes a dir for a  collection
  def check_and_make_dir(mydir_base, mydir)
    if FileTest::directory?(mydir)
      error = "A directory for the collection you entered already exists- Please try again"
      return [false, error]
    else
      if FileTest::directory?(mydir_base)
        Dir::mkdir(mydir)
        return [true,mydir]
      else
        puts "base file dir does not exist"
        return [false, "base file dir does not exist"]
      end
    end
  end

end
