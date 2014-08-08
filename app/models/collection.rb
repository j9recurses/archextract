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

   ##add a plain text record to the preprocesses table
  def self.add_preprocess(collection)
    pp = Preprocess.new(:collection_id => collection[:id], :routine_name => "Plain Text", :status => "complete", :file_dir =>collection[:src_datadir]+ "/input", :fname_base => "orig" )
    if pp.save
      return true
    else
      @create_error  << "Error: Could not create a pre-process record"
      puts @create_error
      return false
    end
  end

  #load up the documents for the collection
  def self.load_documents(collection)
    file_dir =Rails.root.join( "public", "src_corpora", collection[:src_datadir], "input").to_s
    files = Dir.glob( file_dir + "/*")
    for file in files
      fname_list = file.to_s
      fname_list = fname_list.split("/")
      fname =fname_list.last
      dd = Document.new(:collection_id => collection[:id], :name => fname, :file_dir =>collection[:src_datadir]+ "/input")
      if dd.save
        cool = 0
      else
        @create_error  << "Error: Could not create a pre-process record"
        puts @create_error
        return false
      end
    end
    return true
  end



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
