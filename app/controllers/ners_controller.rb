class NersController < ApplicationController
  before_action :set_ner, only: [:show, :edit, :update, :destroy]
   before_filter :authenticate_user!




  # GET /ners
  # GET /ners.json
  def index
    @ner = ExtractNer.find(params[:extract_ner_id])
    puts "******"
    puts @ner[:collection_id]
    @collection = Collection.find(@ner[:collection_id])
    @ner_dates, @ner_orgs, @ner_peeps, @ner_places = Ner.get_types(@collection)
  end

  # GET /ners/1
  # GET /ners/1.json
  def show
    @ner = Ner.find(params[:id])
    @ner_ext = ExtractNer.find(params[:extract_ner_id])
    puts @ner.inspect
    #@collection = Collection.find(@ner_ext[:collection_id])
    @thenerdocs = Ner.ner_documents(@ner)
    @collection = ()
    @thenerdocs = @thenerdocs.paginate(:page => params[:page])
    @similar_items =Ner.ner_similar_items(@ner)
  end

  # GET /ners/1/edit
  def edit
  end

  # DELETE /ners/1
  # DELETE /ners/1.json
  def destroy
    @ner.destroy
    respond_to do |format|
      format.html { redirect_to ners_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ner
      @ner = Ner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ner_params
      params.require(:ner).permit(:nertype, :name, :docs, :count)
    end
end