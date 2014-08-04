class NersController < ApplicationController
  before_action :set_ner, only: [:show, :edit, :update, :destroy]
  before_action :get_collection


 def get_collection
    @collection =  Collection.find(params[:collection_id])
  end



  # GET /ners
  # GET /ners.json
  def index
    @ner_dates, @ner_orgs, @ner_peeps, @ner_places = Ner.get_types(@collection)
  end

  # GET /ners/1
  # GET /ners/1.json
  def show
    @mydocs = Ner.get_documents(@ner)
  end

  # GET /ners/new
  def new
    @ner = Ner.new
  end

  # GET /ners/1/edit
  def edit
  end

  # POST /ners
  # POST /ners.json
  def create
    @ner = Ner.new(ner_params)

    respond_to do |format|
      if @ner.save
        format.html { redirect_to @ner, notice: 'Ner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ner }
      else
        format.html { render action: 'new' }
        format.json { render json: @ner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ners/1
  # PATCH/PUT /ners/1.json
  def update
    respond_to do |format|
      if @ner.update(ner_params)
        format.html { redirect_to @ner, notice: 'Ner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ner.errors, status: :unprocessable_entity }
      end
    end
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
