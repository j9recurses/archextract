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
    @topic_doc = @topic_doc
    @orig_file_contents = TopicDoc.get_original_text(@topic_doc, @extract_topic, @collection)
    @assoc_topics = TopicDoc.get_topic_names(@topic_doc)
  end


end
