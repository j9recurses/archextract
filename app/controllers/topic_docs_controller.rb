
require 'will_paginate/array'
class TopicDocsController < ApplicationController
  before_filter :get_extract_topic
  before_filter :authenticate_user!



  def get_extract_topic
    @extract_topic =  ExtractTopic.find(params[:extract_topic_id])
    @collection  = Collection.find(@extract_topic[:collection_id])
  end

  # GET /topics
  def index
    @topic_docs  = TopicDoc.where(extract_topic_id: @extract_topic[:id])
    @collection  = Collection.find(@topic_docs[:collection_id])
  end

  def show
    @topic_doc = TopicDoc.find(params[:id])
    @collection = Collection.find(@topic_doc[:collection_id])
    pp_routine_name_pre = ExtractTopic.find(@topic_doc[:extract_topic_id])
    @pp_routine_name = pp_routine_name_pre[:routine_name]
    @assoc_topics, @topic_scores = TopicDoc.get_topic_names(@topic_doc)
    doc =  @topic_doc[:name].split(".txt")
    @document = Document.where(name: doc[0])
    @document = @document[0]
    #@docname = docname[0]
  end


end
