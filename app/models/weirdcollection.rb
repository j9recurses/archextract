
      uploaded_io = collection_params[:src_datadir]
      filetype = uploaded_io.content_type
      filename = uploaded_io.original_filename
      collection_name = collection_params[:name]
      name_exists = Collection.find_by(name: collection_params[:name]
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
