require 'zip'
class Collection < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :src_datadir, presence: true, uniqueness: true
  has_many :preprocesses, dependent: :destroy
  has_many :extract_topics, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :topics , :dependent => :destroy
  has_many :topic_docs, :dependent => :destroy
  has_many :ners, :dependent => :destroy
  has_many :extract_ners, :dependent => :destroy



  #method to recursively delete/destory all dirs and files associated with a collection
  def self.destroy_input_files_and_dirs(params)
    collection_id = params[:id]
    collection = Collection.find_by(id: params[:id])
    src_root = "public/src_corpora"
    collection_name = collection.name
    collection_name = collection_name.gsub(" ", "_")
    unless collection_name.nil?
      mydir = Rails.root.join( src_root, collection_name)
      FileUtils.rm_rf(mydir)
    else
      return error =  "Error: No Collection Exists With that Name! "
    end
    return true
  end



end
