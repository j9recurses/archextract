#deletepreprocess

Deletepreprocess  = Struct.new(:preprocess_id) do

  def perform
    @preprocess = Preprocess.find(preprocess_id)
    filedir = Rails.root.join(@preprocess[:file_dir])
    cool = FileUtils.rm_rf(filedir)
    if cool
      @preprocess.destroy
      DeletePreprocessMailer.preprocess_delete(@preprocess[:collection_id], @preprocess , cool).deliver
      return true
    else
      DeletePreprocessMailer.preprocess_delete(@preprocess[:collection_id], @preprocess, cool).deliver
    end
    return false
  end

end
