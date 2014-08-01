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
    @docs = @docs[0..49]
    @doc_dict = Hash.new
    @docs.each do |d |
          doc_name = TopicDocNames.find(d)
          @doc_dict[d] =   doc_name[:name]
    end
  end



end

