module GetCollection
  extend ActiveSupport::Concern
  def get_collection
    @collection =  Collection.find(params[:collection_id])
  end
end
