class ExtractTopicOpts < ActiveRecord::Base

  def initialize
    #make a hash to store record
    @fets = Hash.new
    @error = ''
  end

  def fetch_fets(extract_topics_params, collection)
    chk = check_params(extract_topics_params)
    puts "****check**"
    puts chk

  end

  def check_params(extract_topics_params)
    if extract_topics_params[:preprocess_id].nil?
      @error=  "Error: Please enter a pre-process to generate a topic model from"
    end
    if extract_topics_params[:num_of_topics] > 100
      @error= "Error: Topic model can only have 1-100 topics; Please try again."
    end
    if @error
      return false
    else
      return true
    end
  end

end
