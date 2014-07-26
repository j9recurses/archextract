class ExtractTopicsController < ApplicationController
  include GetCollection
  before_filter :get_collection
  before_action :set_preprocess, only: [:show, :edit, :update, :destroy]


  def get_collection
    @collection =  Collection.find(params[:collection_id])
  end

  # GET /preprocesses
  # GET /preprocesses.json
  def index
    @extracts = ExtractTopic.where(collection_id: @collection[:id])
  end

  # GET /preprocesses/1
  # GET /preprocesses/1.json
  def show
  end

  # GET /preprocesses/new
  def new
    @extract_topic = ExtractTopic.new
    @preprocesses = Preprocess.where(collection_id: @collection, status:"complete")
    @preprocesses_array = {"Plain Text"=> 0}.tap{ |h| @preprocesses.each{ |c| h[c.routine_name] = c.id } }

   end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /extracts
  # POST /extracts.json
  def create
      @myshit = ""
      pp = Preprocess.find(extract_topics_params[:preprocess_id])
      ff = ExtractTopicOpts.new(, @collection,  pp )
      @extract_topic = ff.fetch_fets
      flash[:notice] = @extract_topic
      redirect_to collection_extract_topics_path
      #@extract_topic = Extract.new(extract_params)

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
    @extract = ExtractTopic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def extract_params
    params.require
    (:extract_topic).permit(
      :lda, :num_of_topics, :routine_name, :collection_id,
       :preprocess_id, :status, :fname_base, :file_dir
    )
  end
end





