CollectionImport  = Struct.new( :collection_params, :collection) do

  def perform
    puts "**saving and processing collection files***"
    @collection = collection
    @error = ''
    @root_dir = "public/src_corpora"
    #upload_status=  update_collection_with_file_info(collection_params,  @collection)
  #  job_outcome = update_status(upload_status, @collection )
  #  puts @error
  #  CollectionImportMailer.extract_ner_complete( @collection[:id], job_outcome , @error).deliver
#    if job_outcome && @error.size  == 0
#        add_preprocess(@collection)
#        add_documents(@collection)
  #  end
#  end



def download_collection_files(@collection)
#  wget -rc -l1 --no-parent -A '*.pdf' -R '*.html' -nH -nd -P 'coolio'  http://digitalassets.lib.berkeley.edu/ethnodocs/ucb/text






 def update_collection_with_file_info(collection_params,  collection, params)
    uploaded_io = collection_params[:src_datadir]
    filetype = uploaded_io.content_type
    collection_name = collection[:name]
    upload_status, filesize, file_ext, mimetype = parse_file_upload(uploaded_io, filetype, filename, collection_name,  collection_dir)
          if upload_status
            @collection[:orig_upload_fn] = filename
            @collection[:filesize] = filesize
            @collection[:file_ext] = file_ext
            @collection[:mimetype] = mimetype
          else
            @error = "There was an error"
          end
      upload_status
end



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
    chk, coldef self.check_and_make_dir(mydir)
    if FileTest::directory?(mydir)
      @create_error << "A directory for the collection you entered already exists- Please try again"
      return false
    else
      Dir::mkdir(mydir)
      return [true,mydir]
    end
  end
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

##update the collection process status in the db
  def update_status(upload_status, collection )
    collection_updated = Collection.find(collection[:id])
    if upload_status
      collection_updated.update_column(:status, "complete")
      collection_updated.update(collection)
    else
     collection_updated.update_column(:status, "failed")
    end
  end


    ##add a plain text record to the preprocesses table
  def add_preprocess(collection)
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
  def load_documents(collection)
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
