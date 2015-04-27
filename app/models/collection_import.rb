require 'fileutils'
require 'nokogiri'
require 'open-uri'


CollectionImport  = Struct.new(:collection) do
  def perform
    puts "**saving and processing collection files***"
    rootdir = "public/src_corpora"
    success = ''
    failed = ''
    inputsrc_address = collection[:libserver] + collection[:lib_path]
    #get the file names from the server
    fnames, errormsg = get_fnames(rootdir, collection, inputsrc_address)
    if errormsg == 0
      mkBaseDirs(collection, rootdir)
      #grab the files and turn them into text
      txtDownloadFilesPdf(collection, rootdir, fnames, inputsrc_address)
      #add a preprocess record
      add_preprocess(collection)
      #grab a list of successful and failed documents that were downloaded
      success, failed = successfulDocs(collection)
      puts success
    end
    update_status(collection, errormsg)
    CollectionImportMailer.import_complete(collection, success, failed , errormsg).deliver
  end

  #get the remote dir file names
  def get_fnames(rootdir, collection, inputsrc_address)
    page = Nokogiri::HTML(open(inputsrc_address))
    fnlist = page.css("a")
    flist = Array.new()
    fnlist.each do |f|
      flist << f.text
    end
    fnlistgroup = flist.group_by{ |f| File.extname(f) }
    puts "*****"
    puts fnlistgroup
    puts fnlistgroup[".doc"]
    puts "made it here"
    if fnlistgroup.has_key?(".pdf")
      return fnlistgroup,0
    elsif fnlistgroup.has_key?(".doc")
      puts "in here"
      return fnlistgroup,0
    else
      error = "Error: No files listed on that path"
      return 0, error
    end
  end

  #download the input files
  def txtDownloadFilesPdf(collection, rootdir, fnames, inputsrc_address)
    counter = 0
    if FileTest::directory?(Rails.root.join(rootdir, collection[:src_datadir], 'input'))
      filetypes = [".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx"]
      filetypes.each do | filetype|
        unless fnames[filetype].nil?
          fnames[filetype].each do | fn|
          #  if counter < 1
              plaintextsuccess = false
              begin
                puts inputsrc_address+ fn
                encoded_url = URI.encode(inputsrc_address+ fn)
                decoded_url = URI.parse(encoded_url)
                #grab the file off the ftp
                yomu = Yomu.new decoded_url
                pagetext = yomu.text
                unless pagetext.nil?
                  goodtext = checkText(pagetext)
                  unless goodtext.nil?
                    plaintextsuccess = mkPlainTextFile(fn, filetype, goodtext, collection, rootdir)
                  #  counter = counter + 1
                  end
                end
              rescue Exception => e
                puts e.message
                #logger.debug "There was an error: #{e.message}"
              end
              mkDocumentRecord(collection, fn, filetype, plaintextsuccess)
            #end
          end
        end
      end
    end
  end

  def checkText(pagetext)
    #checks the text to try to clean out some the obvious dirty OCR
    goodtext = Array.new()
    pagetext = pagetext.split("\n")
    pagetext.each do | txt|
  	  #strip control characters
  	  txt = txt.strip.gsub(/[[:cntrl:]]/, "")
  	  #check number of puncs per line to make sure its not crazy
  	  weirdcnt  = txt.scan(/[[:punct:]]/).size
  	  if weirdcnt < 10
  		  goodtext << txt
  	  end
    end
    finaltext = goodtext.join(" ")
    return finaltext
  end

  def mkPlainTextFile(filename, filetype, pagetext, collection, rootdir)
    #make a plain text file of the document
    begin
      plainfn =  filename.gsub(filetype, '')
      fnplaintext = Rails.root.join(rootdir, collection[:src_datadir], 'input', plainfn + ".txt")
      File.open(fnplaintext , 'w') {|f| f.write(pagetext) }
    rescue Exception => e
      puts e.message
      #logger.debug "There was an error: #{e.message}"
    end
    if File.exist?(fnplaintext)
      return true
    else
      return false
    end
  end


  def mkBaseDirs(collection, rootdir)
    #make the basedirs
    basedirs = ['input', 'preprocess', 'extract', 'extract/ner', 'extract/topics']
      basedirs.each do | bd|
        dirmk = Rails.root.join(rootdir, collection[:src_datadir], bd)
        FileUtils.mkdir_p dirmk
      end
  end

  def mkDocumentRecord(collection, filename, filetype, downloaded)
    #make a document record in the db
    dt = Document.new
    dt[:name] = filename.gsub(filetype, '')
    dt[:filetype] = filetype
    dt[:collection_id] = collection[:id]
    dt[:file_dir] = collection[:src_datadir]+ "/input"
    dt[:downloaded] = downloaded
    if dt.save()
      return true
    else
      return false
    end
  end


  ##add a plain text record to the preprocesses table
  def add_preprocess(collection)
    error_pp  = ''
    pp = Preprocess.new(:collection_id => collection[:id], :routine_name => "Plain Text", :status => "complete", :file_dir =>collection[:src_datadir]+ "/input", :fname_base => "orig" )
    if !pp.save
      error_pp  = "Error: Could not create a pre-process record"
    end
    return error_pp
  end

  def successfulDocs(collection)
    #find the docs that were downloaded and not downloaded.
    sucString = ''
    failedString = ''
    sucdocs =Document.where(collection_id: collection[:id], downloaded: true).pluck(:name, :filetype)
    faileddocs = Document.where(collection_id: collection[:id], downloaded:false).pluck(:name, :filetype)
    unless sucdocs.nil?
      sucdocs.each do | doc|
        sucString =  sucString + doc.join("") + ","
      end
      sucString = sucString[0...-1]
    end
    unless faileddocs.nil?
      faileddocs.each do | doc|
        failedString =failedString + doc.join("") + ","
      end
      failedString = failedString[0...-1]
    end
    return sucString, failedString
  end

  def update_status(collection, errormsg)
    #update the collection status
    collectiondone = Collection.find(collection[:id])
    if errormsg == 0
      collectiondone.update_column(:status, "complete")
    else
      collectiondone.update_column(:status, "failed")
    end
  end

end
