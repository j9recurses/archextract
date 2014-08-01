require 'fileutils'

class ExtractTopicOpts < ActiveRecord::Base

  def initialize(extract_topic_params, collection)
    #make a hash to store record
    @fets = Hash.new
    @error = ''
    @extract_topic_params = extract_topic_params
    @collection = collection
    @preprocess = Preprocess.find(extract_topic_params[:preprocess_id])
    @mlinout = ''
  end

  #make an active record object based on params.
  def fetch_fets
    chk = check_params
    unless @error.size > 1
      @fets[:lda] = true
      @fets[:num_of_topics] = @extract_topic_params[:num_of_topics]
      @fets[:routine_name] = @preprocess[:routine_name] + " with " + @extract_topic_params[:num_of_topics].to_s+" Topics"
      @fets[:collection_id] = @collection[:id]
      @fets[:preprocess_id] = @preprocess[:id]
      @fets[:fname_base]  = @preprocess[:fname_base] + "_lda_" + @extract_topic_params[:num_of_topics].to_s
      file_dir = [@collection[:src_datadir], "extract", "topics" ,  @preprocess[:fname_base]+"_lda" +@extract_topic_params[:num_of_topics].to_s]
      @fets[:file_dir] = file_dir.join("/")
      @fets[:status] = 'processing'
      return [@fets, @error]
    else
      return [@fets, @error]
    end
  end

  #check the params for funny biz
  def check_params
    if !@extract_topic_params[:preprocess_id].present?
        @error=  "Error: Please enter a pre-process to generate a topic model from"
      elsif !@extract_topic_params[:num_of_topics].present?
        @error = "Error: Please enter the number of topics you'd like to generate"
      elsif @extract_topic_params[:num_of_topics].to_i > 100
          @error= "Error: Topic model can only have 1-100 topics; Please try again."
      end
  end

  #create the command line args for mallet and the necessary dirs to store the mallet files
  def cmd_line_args
    cn = @collection[:name].gsub(" ", "_")
    pp_indir = Rails.root.join(  "public/src_corpora",  @preprocess[:file_dir]).to_s
    mlindir = Rails.root.join( "public/src_corpora",  @fets[:file_dir],  "mallet_in").to_s
    @mlinout = Rails.root.join( "public/src_corpora",  @fets[:file_dir],  "mallet_out").to_s
    create_directory_if_not_exists(mlindir)
    create_directory_if_not_exists(mlinout)
    cn_in = mlindir +"\/" + cn + "_"  +@fets[:fname_base] + "_corpus.mallet"
    cn_state = mlinout + "\/" +cn + "_"  + @fets[:fname_base] +"_topic_state.gz"
    cn_outkeys = mlinout + "\/" +cn+ "_"  + @fets[:fname_base]   +"_topic_keys.txt"
    cn_tops = mlinout  +"\/" +cn + "_"  + @fets[:fname_base]    +  "_doc_topics.txt"
    mlimport =  "mallet import-dir --input " +  pp_indir + " --output " + cn_in +" --keep-sequence --remove-stopwords --token-regex '[\\p{L}\\p{M}]+'"
    mloutput ="mallet train-topics --input " + cn_in + " --num-topics " +  @fets[:num_of_topics] +" --output-state " + cn_state +" --output-topic-keys " + cn_outkeys +" --output-doc-topics "+ cn_tops
    return mlimport,  mloutput
  end

  def cmd_line_args_db
    #EX: of cmd line args: python parse_mallet_out.py -d /home/j9/Desktop/archextract/public/src_corpora/John_Muir/extract/topics/tfidf_btm_lda34/mallet_out -z John_Muir_tfidf_btm_lda_34_doc_topics.txt -t John_Muir_tfidf_btm_lda_34_topic_keys.txt -c 1 -p 4 -e 3 -v development



  def create_directory_if_not_exists(directory_name)
    FileUtils::mkdir_p directory_name unless File.exists?(directory_name)
  end

end



