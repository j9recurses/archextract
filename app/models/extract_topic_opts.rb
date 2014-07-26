class ExtractTopicOpts < ActiveRecord::Base

  def initialize(extract_topics_params, collection, preprocess)
    #make a hash to store record
    @fets = Hash.new
    @fets[:lda] = true
    @fets[:preprocess_id] = extract_topics_params[:preprocess_id]
    @fets[:num_of_topics] = extract_topics_params[:num_of_topics]
    @fets[:collection_id] = collection[:id]
    @fets[:routine_name] = ''
    @fets[:status] = 'processing'
    @fets[:fname_base]  = preprocess[:fname_base] + "_mltop"
    file_dir = Array(collection[:name],  "extract",  "extract_topics", "ext_input",  "ext_output")
    @fets[:file_dir]  = file_dir.join("/")
    tznumb = @fets[:num_of_topics].to_s
    @fets[:froutine_name] = preprocess[:routine_name] + "_" + tznumb+"_topics"
  end

  def fetch_fets
    return @fets
  end

  end



