class TopicDocsController < ApplicationController
  before_filter :get_collection
  before_filter :get_extract_topic

   def get_collection
    @collection =  Collection.find(params[:collection_id])
  end

  def get_extract_topic
    @extract_topic =  ExtractTopic.find(params[:extract_topic_id])
  end

  # GET /topics
  def index
        @topic_docs  = TopicDoc.where(collection_id: @collection[:id], extract_topic_id: @extract_topic[:id])
  end

  def show
    @topic_doc = TopicDoc.find(params[:id])
    @assoc_topics =  eval(@topic_doc[:topics])
    @orig_file_contents = TopicDoc.get_original_text(@topic_doc, @extract_topic, @collection)
  end


end
