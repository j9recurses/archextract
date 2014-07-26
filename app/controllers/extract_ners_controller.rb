class ExtractNersController < ApplicationController
  before_action :set_extract_ner, only: [:show, :edit, :update, :destroy]

  # GET /extract_ners
  # GET /extract_ners.json
  def index
    @extract_ners = ExtractNer.all
  end

  # GET /extract_ners/1
  # GET /extract_ners/1.json
  def show
  end

  # GET /extract_ners/new
  def new
    @extract_ner = ExtractNer.new
  end

  # GET /extract_ners/1/edit
  def edit
  end

  # POST /extract_ners
  # POST /extract_ners.json
  def create
    @extract_ner = ExtractNer.new(extract_ner_params)

    respond_to do |format|
      if @extract_ner.save
        format.html { redirect_to @extract_ner, notice: 'Extract ner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @extract_ner }
      else
        format.html { render action: 'new' }
        format.json { render json: @extract_ner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /extract_ners/1
  # PATCH/PUT /extract_ners/1.json
  def update
    respond_to do |format|
      if @extract_ner.update(extract_ner_params)
        format.html { redirect_to @extract_ner, notice: 'Extract ner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @extract_ner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extract_ners/1
  # DELETE /extract_ners/1.json
  def destroy
    @extract_ner.destroy
    respond_to do |format|
      format.html { redirect_to extract_ners_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extract_ner
      @extract_ner = ExtractNer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extract_ner_params
      params.require(:extract_ner).permit(:status, :fname_base, :file_dir, :status)
    end
end
