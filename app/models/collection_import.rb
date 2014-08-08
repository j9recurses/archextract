CollectionImport  = Struct.new( :collection_params, :params, :collection) do

  def perform
    puts "**extracting ners job***"
    @collection = collection
    @error = ''
    job_status =  run_pyjob(server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job)
    job_outcome = update_status(job_status, extract_topic )
    puts @error
    ExtractNersMailer.extract_ner_complete( @collection[:id], job_outcome , @error).deliver
  end
#######
| name               | varchar(255) | YES  |     | NULL    |                |
| acquisition_date   | date         | YES  |     | NULL    |                |
| acquisition_source | varchar(255) | YES  |     | NULL    |                |
| src_datadir        | varchar(255) | YES  |     | NULL    |                |
| notes              | text         | YES  |     | NULL    |                |
| isdir              | tinyint(1)   | YES  |     | NULL    |                |
| is_processed       | tinyint(1)   | NO   |     | 0       |                |
| orig_upload_fn     | varchar(255) | YES  |     | NULL    |                |
| mimetype           | varchar(255) | YES  |     | NULL    |                |
| filesize           | int(11)      | YES  |     | NULL    |                |
| file_ext


 def update_collection_with_file_info(collection_params, params, collection)
    uploaded_io = collection_params[:src_datadir]
    filetype = uploaded_io.content_type
    collection_name = collection[:name]
    upload_status, filesize, file_ext, mimetype = parse_file_upload(uploaded_io, filetype, filename, collection_name,  collection_dir)
          if upload_status
            save_hash[:src_datadir] = collection_dir
            save_hash[:orig_upload_fn] = filename
            save_hash[:filesize] = filesize
            save_hash[:file_ext] = file_ext
            save_hash[:mimetype] = mimetype
          else




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



end
