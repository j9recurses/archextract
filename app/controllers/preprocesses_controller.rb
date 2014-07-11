class PreprocessesController < ApplicationController
  before_filter :get_collection
  before_action :set_preprocess, only: [:show, :edit, :update, :destroy]

  def get_collection
    @collection =  Collection.find(params[:collection_id])
  end


  # GET /preprocesses
  # GET /preprocesses.json
  def index
    @preprocesses = @collection.preprocesses
  end

  # GET /preprocesses/1
  # GET /preprocesses/1.json
  def show
  end

  # GET /preprocesses/new
  def new
    @preprocess = Preprocess.new
  end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /preprocesses
  # POST /preprocesses.json
  def create
    pp = Preprocesscollectionopts.new(preprocess_params, @collection )
    @preprocess = pp.get_preprocess_stem_tag_cmd_short
    if pp.check_if_preprocess_exists?
      flash[:error] =  "Error: Your Preprocess routine exists!"
      redirect_to collection_preprocesses_path
    else
      #Delayed::Job.enqueue Preprocesscollection.new(preprocess_params, params[:collection_id] )
      @preprocess = Preprocess.new(@preprocess)
      if @preprocess.save
        flash[:notice] =  'Thank you for submission: The Pre-Process job is now running'
        redirect_to collection_preprocesses_path
      else
        flash[:error] =  "Error: Your Preprocess routine could not be completed!"
        redirect_to collection_preprocesses_path
      end
    end
  end

  # PATCH/PUT /preprocesses/1
  # PATCH/PUT /preprocesses/1.json
  def update
    respond_to do |format|
      if @preprocess.update(preprocess_params)
        format.html { redirect_to @preprocess, notice: 'Preprocess was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @preprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preprocesses/1
  # DELETE /preprocesses/1.json
  def destroy
    @preprocess.destroy
    respond_to do |format|
      format.html { redirect_to preprocesses_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_preprocess
    @preprocess = Preprocess.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def preprocess_params
    params.require(:preprocess).permit(
      :stopwords,
      :rarewords,
      :custom_stoplist,
      :tagged_no_ner,
      :tfidf,
      :stemmed,
      :collection_id,
      :file_dir,
      :fname_base,
      :pos => []
    )
  end
end
