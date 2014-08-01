class ExtractTopicsController < ApplicationController
  include GetCollection
  before_filter :get_collection
  before_action :set_preprocess, only: [:show, :edit, :update, :destroy]

  def get_collection
    @collection =  Collection.find(params[:collection_id])
  end

  # GET /preprocesses
  def index
    @extract_topics = ExtractTopic.where(collection_id: @collection[:id])
  end

  # GET /preprocesses/1
  # GET /preprocesses/1.json
  def show
  end

  # GET /preprocesses/new
  def new
    @extract_topic = ExtractTopic.new
    @preprocesses = Preprocess.where(collection_id: @collection, status:"complete")
    @preprocesses_array = {}.tap{ |h| @preprocesses.each{ |c| h[c.routine_name] = c.id } }
  end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /extracts
  # POST /extracts.json
  def create
    @myshit = ""
    ff = ExtractTopicOpts.new(params[:extract_topic], @collection)
    @extract_topic, @error = ff.fetch_fets
    if @error.size >1
       flash[:error] = @error
       redirect_to collection_extract_topics_path
    else
      @extract_topic = ExtractTopic.new(@extract_topic)
      if @extract_topic.save
        flash[:notice]  = 'Thank you for your submission: The Topic Model job for the '+  @collection[:name] + ' is now running. You will be sent an email when the job is done.'
        mlin, mlout  = ff.cmd_line_args
        Delayed::Job.enqueue ExtractTopicRunModel.new(mlin, mlout, @extract_topic)
        redirect_to collection_extract_topics_path
         #  flash[:notice] = @extract_topic
           #redirect_to collection_extract_topics_path
      else
          flash[:error] = "Could not save process topic model"
          redirect_to collection_extract_topics_path
      end
    end
  end



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
  def extract_topic_params
    params.require
    (:extract_topic).permit(
      :lda, :num_of_topics, :routine_name, :collection_id,
      :preprocess_id, :status, :fname_base, :file_dir
    )
  end
end
