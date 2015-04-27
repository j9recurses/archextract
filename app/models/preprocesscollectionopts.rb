class Preprocesscollectionopts
 attr_accessor :preprocess, :collection_id

  #{"stopwords"=>"true", "rarewords"=>"true", "pos"=>["NN", ""], "tagged_no_ner"=>"true", "stemmed"=>"true", "tfidf"=>"true"},

  def initialize(preprocess, collection)
    @preprocess = preprocess
    @collection = collection
     @preprocess[:collection_id] = collection[:id]
    @outdir = Array.new()
    @routine = Array.new()
    @error = ''
  end

  def get_preprocess_stem_tag_cmd_short
    get_pos
    no_ner
    stemmed
    stopwords
    rarewords
    tfidf
    collection_outdir_and_filout
    parse_routine
    return @preprocess, @error
  end

  #checks to see if the preprocess exists
  def preprocess_exists?(preprocess, collection)
    preprocess_chk = Preprocess.find_by routine_name: preprocess[:routine_name]
    if preprocess_chk
      pp_error = 'Error: Your preprocess routine for the ' + collection[:name] + ' collection already exists!'
      return true, pp_error
    else
      return false
    end
  end

  def parse_routine
    theroutine = @routine.join(", ")
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
      @routine << "Stemmed"
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
      puts "in here"
      @outdir << "rare_words"
      @routine << "Removed Rare Words"
    end
  end

  def tfidf
    if @preprocess[:tfidf_score] == ""
      @preprocess[:tfidf_score] = nil
    end
    if @preprocess[:tfidf_btm] and !@preprocess[:tfidf_score].nil?
      @error = "Error: Cannot process BOTH the tfidf score below the mean and a tfidf score; Please select ONE"
    end
    if @preprocess[:tfidf_btm] or !@preprocess[:tfidf_score].nil?
      if @preprocess[:stemmed] or @preprocess[:tagged_no_ner] or @preprocess[:pos].size > 1
        @error = "Error: the Tf-idf cannot be used in combination with Stemming or Tagging"
      end
      if @preprocess[:tfidf_btm]
        @preprocess[:tfidf] =  true
        @outdir << "tfidf_btm"
        @routine <<  "TF-IDF Below the Mean"
      elsif !@preprocess[:tfidf_score].nil?
        puts "in heree ****tif idfi not null"
        if @preprocess[:tfidf_score].to_f > 3 or @preprocess[:tfidf_score].to_f < 0
         @error = "Error: tfidf score to filter by must be less than 3 but greater than zero."
        else
          @preprocess[:tfidf] =  true
          tfscore_new = @preprocess[:tfidf_score].sub('.', 'p')
          @outdir << "tfidf_score_" + tfscore_new
          @routine << "TF-IDF Below" + @preprocess[:tfidf_score].to_s
        end
      end
    end
  end



  #sets file and outdirs for pre-process
  def collection_outdir_and_filout
    outdir_opts = @outdir.join("_")
    outdir_base = Rails.root.join( "public/src_corpora", @collection[:src_datadir], "preprocess")
    outdir =  @collection[:src_datadir] + "/preprocess/" + outdir_opts
    @preprocess[:file_dir] = outdir.to_s
    @preprocess[:fname_base] = outdir_opts
  end

end
