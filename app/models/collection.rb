require 'zip'
class Collection < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :src_datadir, presence: true, uniqueness: true
  has_many :preprocesses, dependent: :destroy
  has_many :extract_topics, dependent: :destroy
  has_many :topics , :dependent => :destroy
  has_many :topic_docs, :dependent => :destroy
  has_many :documents, :dependent => :destroy


  def self.parse_collection_params(collection_params, params)
    @create_error = Array.new
    if collection_params[:src_datadir].nil?
      @create_error = "Error: Please select a file to upload"
      return [@create_error, false]
    else
      uploaded_io = collection_params[:src_datadir]
      filetype = uploaded_io.content_type
      filename = uploaded_io.original_filename
      collection_name = collection_params[:name]
      is_dir = collection_params[:isdir]
      name_exists = Collection.find_by(name: collection_params[:name])
      fname_exists = Collection.find_by(orig_upload_fn: filename)
      collection_dir = collection_params[:name]
      collection_dir = collection_dir.gsub(/\s+/, "_")
      if name_exists.nil? and fname_exists.nil?
        save_hash = Hash.new()
        save_hash[:name] = collection_params[:name]
        mydate = parse_acq_date(collection_params)
        if mydate
          save_hash[:acquisition_date] = mydate
        end
        chckaqsrc = collection_params[:acquisition_source].empty?
        if chckaqsrc == false
          save_hash[:acquisition_source] = collection_params[:acquisition_source]
        end
        chcknotes = collection_params[:notes].empty?
        if chcknotes == false
          save_hash[:notes] = collection_params[:notes]
        end
        save_hash[:isdir] =collection_params[:isdir]
        chckupl = collection_params[:src_datadir].nil?
        if chckupl == false
          upload_status, filesize, file_ext, mimetype = self.parse_file_upload(uploaded_io, filetype, filename, collection_name,  collection_dir)
          if upload_status
            save_hash[:src_datadir] = collection_dir
            save_hash[:orig_upload_fn] = filename
            save_hash[:filesize] = filesize
            save_hash[:file_ext] = file_ext
            save_hash[:mimetype] = mimetype
          else
            @create_error << "Could not upload file"
            return [ @create_error , false]
          end
        end
      else
        if name_exists
          @create_error << "Error: A collection by name already exists. Please double check your collection and try again"
          return [@create_error, false]
        end
        if fname_exists
          @create_error << "Error: The file you are trying to upload has already been uploaded"
          return [ @create_error , false]
        end
      end
      return [save_hash, true]
    end
  end

  #parse and temporily uploads file to hold a directory
  #creates a unique directory for the collection and tries to unzip the file based on extension
  def self.parse_file_upload(uploaded_io, filetype, filename, collection_name,  collection_dir)
    mimchk, mimefiletype =  self.check_mime_types(filename, filetype)
    if mimchk
      worked, collection_dir, filesize, file_ext, mimetype = self.save_upload_file( collection_dir, uploaded_io, mimefiletype)
      puts worked
      puts collection_dir
      puts filesize
      puts file_ext
      puts mimetype
      if worked
        return [true,  filesize, file_ext, mimetype]
      else
        return false
      end
    else

      return false
    end
  end

  ##checks the mime types of the file to make sure its either gzip, zip, tar, or plain text
  #returns the mime type, which is used in the later methods
  def self.check_mime_types(filename, filetype)
    mimetypes2 = [[1,'application/zip'], [2,'application/x-gzip'], [3,'application/x-tar'], [4,'text/plain']]
    mimetypes = Hash[*mimetypes2.flatten(1)]
    mimechktype = mimetypes.key(filetype)
    if mimechktype.nil?
      return [false, filetype]
    else
      return [true, filetype ]
    end
  end

  #returns whether if the file saved, collection_dir, filesize, file_ext, mimetype
  def self.save_upload_file(collection_dir, uploaded_io, mimefiletype )
    src_root = "public/src_corpora"
    filesize = ''
    file_ext = ''
    mime_type =''
    mydir = Rails.root.join( src_root, collection_dir)
    chk, collection_dir = check_and_make_dir(mydir)
    if chk
      puts "in the check!"
      fname = Rails.root.join(src_root, collection_dir, uploaded_io.original_filename)
      File.open(fname, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      #save the file size in the active record object
      filesize =  File.stat(fname.to_s).size
      #save the file extension in the active record
      file_ext =  File.extname(fname.to_s).sub( /^\./, '' ).downcase
      #now unzip/process particular file types
      chk2, myinputdir = make_file_src_dirs(src_root, collection_dir)
      if chk2
        puts "******MIMECHCK TYPE***"
        puts mimefiletype
        #save the mimetype in active record object
        mimetype = mimefiletype
        #open zip files
        if mimefiletype  == 'application/zip'
          unzip_files(fname, myinputdir)
        elsif mimechktype == 2
        elsif mimechktype == 3
        elsif mimechktype == 4
        end
        puts "I'm here"
        return [true, collection_dir, filesize, file_ext, mimetype]
      else
        return [false, inputdirerror]
      end
    else
      return [false, collection_dir]
    end
  end


  #makes source dirs for a collection
  def self.make_file_src_dirs(src_root,  collection_dir)
    dirs = [ 'input', 'preprocess', 'extract', 'extract/ner', 'extract/topics']
    chk2 = true
    inputdirerror = ''
    dirs.each do | d|
      myinputdir = Rails.root.join( src_root,  collection_dir, d)
      chk2 = check_and_make_dir(myinputdir)
      if chk2 == false
        @create_error << "Error: Could not make collection dirs"
        return false
      end
    end
    return [chk2, Rails.root.join( src_root,  collection_dir, 'input') ]
  end

  #checks and makes a dir for a  collection
  def self.check_and_make_dir(mydir)
    if FileTest::directory?(mydir)
      @create_error << "A directory for the collection you entered already exists- Please try again"
      return false
    else
      Dir::mkdir(mydir)
      return [true,mydir]
    end
  end

  #method to unzip uploaded zip file
  def self.unzip_files(fname, collection_dir)
    Zip::File.open(fname) do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        dest_file = Rails.root.join( collection_dir, entry.name)
        entry.extract(dest_file)
      end
    end
  end



  #parses params for the aquistion date
  def self.parse_acq_date(collection_params)
    year = ''
    month = ''
    day = ''
    chck = collection_params["acquisition_date(1i)"].empty?
    if chck == false
      year = collection_params["acquisition_date(1i)"]
    end
    chck2 = collection_params["acquisition_date(2i)"].empty?
    if chck2 == false
      if  collection_params["acquisition_date(2i)"].size  < 2
        month = "0"+ collection_params["acquisition_date(2i)"]
      else
        month = collection_params["acquisition_date(2i)"]
      end
    end
    chck3  = collection_params["acquisition_date(3i)"].empty?
    if chck3 == false
      if  collection_params["acquisition_date(3i)"].size  < 2
        day = "0"+ collection_params["acquisition_date(3i)"]
      else
        day = collection_params["acquisition_date(3i)"]
      end
    end
    mydate = year + month + day
    return mydate
  end

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

  #method to recursively delete/destory all dirs and files associated with a collection
  def self.destroy_input_files_and_dirs(params)
    collection_id = params[:id]
    collection = Collection.find_by(id: params[:id])
    src_root = "public/src_corpora"
    collection_name = collection.name
    unless collection_name.nil?
      mydir = Rails.root.join( src_root, collection_name)
      FileUtils.rm_rf(mydir)
    else
      return error =  "Error: No Collection Exists With that Name! "
    end
    return true
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

end
