
require 'will_paginate/array'
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
    @orig_file_contents = TopicDoc.get_original_text(@topic_doc[:id], @extract_topic, @collection)
    @chopped_file_contents, @pp_routine_name = TopicDoc.get_chopped_text(@topic_doc)
    @assoc_topics, @topic_scores = TopicDoc.get_topic_names(@topic_doc)
    docname = @topic_doc[:name].split(".")
    @docname = docname[0] + ".txt"
  end


end
