
class CollectionImportOpts
    def initialize
      @collection = Hash.new()
      @create_error = ''
    end

    def make_collection(collection_params)
      @create_error = Array.new
      chk  = false
      uploaded_io = collection_params[:src_datadir]
      collection_dir = collection_params[:name].gsub(/\s+/, "_")
      collection_chk =  collection_chk?(uploaded_io, collection_params)
      if collection_chk
        chk = true
      end
      return chk, @create_error
    end


    #check some basic stuff before creating a collection record
    def collection_chk?(uploaded_io, collection_params)
      cname = Collection.find_by(name: collection_params[:name])
      fname = Collection.find_by(orig_upload_fn:  uploaded_io.original_filename)
      cna
        @create_error = "Error: A collection by name already exists. Please double check your collection and try again"
         return false
      elsif fname
        @create_error = "Error: The file you are trying to upload has already been uploaded"
        return false
      elsif collection_params[:src_datadir].nil?
        @create_error = "Error: Please select a file to upload"
        return false
      else
        return true
      end
    end

  #parses params for the aquistion date
  def parse_acq_date(collection_params)
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

end
