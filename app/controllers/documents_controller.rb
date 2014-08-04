class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :get_collection

def get_collection
    @collection =  Collection.find(params[:collection_id])
    session[:collection_id] = @collection[:id]
  end


  # GET /documents
  def index
        @documents  = Document.paginate(page: params[:page], per_page: 15)
  end

  # GET /documents/1
  def show
    @contents = Document.get_original_text(@document, @collection)
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
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:name, :collection_id, :file_dir)
    end
end
