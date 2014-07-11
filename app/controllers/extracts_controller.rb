class ExtractsController < ApplicationController
  include GetCollection
  before_filter :get_collection
  before_action :set_preprocess, only: [:show, :edit, :update, :destroy]


  def get_collection
    @collection =  Collection.find(params[:collection_id])
  end

  # GET /preprocesses
  # GET /preprocesses.json
  def index
    @extracts = @collection.extracts
  end

  # GET /preprocesses/1
  # GET /preprocesses/1.json
  def show
  end

  # GET /preprocesses/new
  def new
    @extract = Extract.new
  end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /extracts
  # POST /extracts.json
  def create
    #  @extract = Extract.new(extract_params)

    # respond_to do |format|
    #    if @extract.save
    #     format.html { redirect_to @extract, notice: 'Extract was successfully created.' }
    #      format.json { render action: 'show', status: :created, location: @extract }
    #    else
    #   format.html { render action: 'new' }
    #    format.json { render json: @extract.errors, status: :unprocessable_entity }
    #    end
    #  end
  end

  # PATCH/PUT /extracts/1
  # PATCH/PUT /extracts/1.json
  def update
    #  respond_to do |format|
    #   if @extract.update(extract_params)
    #      format.html { redirect_to @extract, notice: 'Extract was successfully updated.' }
    #     format.json { head :no_content }
    #    else
    #      format.html { render action: 'edit' }
    #     format.json { render json: @extract.errors, status: :unprocessable_entity }
    #   end
    #  end
  end

  # DELETE /extracts/1
  # DELETE /extracts/1.json
  def destroy
    #  @extract.destroy
    #  respond_to do |format|
    #    format.html { redirect_to extracts_url }
    #   format.json { head :no_content }
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_extract
    @extract = Extract.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def extract_params
    params.require(:extract).permit(:lda, :num_of_topics, :ner_people, :ner_organizations, :ner_places, :ner_dates)
  end
end
