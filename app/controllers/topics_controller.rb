class TopicsController < ApplicationController
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
        @topics  = Topic.where(collection_id: @collection[:id], extract_topic_id: @extract_topic[:id])
  end

  def show
    @topic = Topic.find(params[:id])
    @docs = eval(@topic[:docs])
  end



end

