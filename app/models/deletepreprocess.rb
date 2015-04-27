Deletepreprocess  = Struct.new(:preprocess) do
  def perform
    @preprocess = Preprocess.find(preprocess)
    filedir = Rails.root.join("public", "src_corpora", @preprocess[:file_dir])
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
