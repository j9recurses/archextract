class Preprocesscollectionopts
 attr_accessor :preprocess, :collection_id

  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  def initialize(preprocess, collection)
    @preprocess = preprocess
    @collection = collection
     @preprocess[:collection_id] = collection[:id]
    @outdir = Array.new()
    @routine = Array.new()
  end

  def get_preprocess_stem_tag_cmd_short
    get_pos
    no_ner
    stemmed
    stopwords
    rarewords
    collection_outdir_and_filout
    parse_routine
    return @preprocess
  end

  #checks to see if the preprocess exists
  def check_if_preprocess_exists?
    preprocess_chk = Preprocess.find_by(:routine_name,@preprocess[:routine_name])
    if preprocess_chk
      return true
    end
    return false
  end

  def parse_routine
    theroutine = @routine.join(",")
    @preprocess[:routine_name] = theroutine
  end

  def get_pos
    if @preprocess[:pos].size > 1
      the_pos =@preprocess[:pos]
      new_pos =  the_pos.join('_')
      new_pos = new_pos.chomp("_")
      thepos = new_pos
      @outdir << "tagged"
      @outdir << new_pos
      myroutine = "Tagged-"
      if the_pos.include? "NN"
         myroutine =  myroutine + "-Nouns-"
      end
      if the_pos.include? "VB"
         myroutine =  myroutine + "-Verbs-"
      end
      if  the_pos.include? "JJ"
        myroutine =  myroutine + "-Adjectives-"
      end
      myroutine = myroutine[0..-2]
      puts myroutine
      @routine  << myroutine
    end
  end

  def no_ner
    if @preprocess[:tagged_no_ner]
      @outdir << "no_ner"
      @routine << "Removed Named Entities"
    end
  end

  def stemmed
    if @preprocess[:stemmed]
      @outdir << "stemmed"
      @routine << "stemmed"
    end
  end

  def stopwords
    if @preprocess[:stopwords]
      @outdir << "stopwords"
      @routine << "Removed Stop Words"
    end
  end

  def rarewords
    if @preprocess[:rarewords]
      @outdir << "rare_words"
      @routine << "Removed Rare Words"
    end
  end

  #sets file and outdirs for pre-process
  def collection_outdir_and_filout
    outdir_opts = @outdir.join("_")
    outdir_base = Rails.root.join( "public/src_corpora", @collection[:src_datadir], "preprocess")
    outdir = "public/src_corpora/" +  @collection[:src_datadir] + "/preprocess/" + outdir_opts
    @preprocess[:file_dir] = outdir.to_s
    @preprocess[:fname_base] = outdir_opts
    puts  @preprocess
  end

end
