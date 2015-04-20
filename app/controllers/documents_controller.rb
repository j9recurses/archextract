class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  #before_action :get_collection
  before_filter :authenticate_user!




  # GET /documents
  def index
    @document_groups = Array.new
    @collections = Collection.all
    @collections.each do | collection|
      docHash = {}
      docHash["collection_name"] = collection["name"]
      docHash["document_group"]  = Document.where(collection_id: collection[:id]).paginate(page: params[:page], per_page: 15)
      #docHash["document_group"]  = Document.where(collection_id: collection[:id])S
      @document_groups << docHash
    end
  end

  # GET /documents/1
  def show
    @document = Document.friendly.find(params[:id])
    @doc_collection  = Collection.find(@document[:collection_id])
    #@contents = Document.get_original_text(@document, @collection_src)
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end



  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:name, :collection_id, :file_dir)
    end
end
