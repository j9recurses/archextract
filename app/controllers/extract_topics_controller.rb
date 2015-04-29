class ExtractTopicsController < ApplicationController
  before_filter  :authenticate_user!
  before_action :set_extract, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_authorize_resource :except => [:index, :show]

  # GET /preprocesses
  def index
    @extract_topics  = ExtractTopic.joins(:collection).select('extract_topics.routine_name, extract_topics.id, collections.name, extract_topics.status, extract_topics.updated_at')

  end

  # GET /preprocesses/1
  # GET /preprocesses/1.json
  def show
  end

  # GET /preprocesses/new
  def new
    @extract_topic = ExtractTopic.new
    @collections = Collection.all
    @collections_array = {}.tap{ |h| @collections.each{ |c| h[c.name] = c.id } }
    @preprocesses = Preprocess.joins(:collection).where(status:"complete")
    @preprocesses_array = {}.tap{ |h| @preprocesses.each{ |c| h[c.routine_name] = c.routine_name } }
  end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /extracts
  # POST /extracts.json
  def create
    if extract_topic_params[:collection_id].blank?
      flash[:error] =  'Error: Please select a collection to run the topic modeling on'
      redirect_to new_extract_topic_path
    else
      @collection = Collection.find(extract_topic_params[:collection_id])
      puts params[:extract_topic].inspect
      ff = ExtractTopicOpts.new(params[:extract_topic], @collection)
      @extract_topic, @error = ff.fetch_fets
      if @error.size >1
        flash[:error] = @error
        redirect_to new_extract_topic_path
      else
        @extract_topic = ExtractTopic.new(@extract_topic)
        if @extract_topic.save
          flash[:notice]  = 'Thank you for your submission: The Topic Model job for the '+  @collection[:name] + ' is now running. You will be sent an email when the job is done.'
          mlin, mlout  = ff.cmd_line_args
          puts "****"
          puts mlin
          puts "******"
          puts mlout
          dbcmd = ff.cmd_line_args_db(@extract_topic)
          puts "*****"
          puts dbcmd
          Delayed::Job.enqueue ExtractTopicRunModel.new(mlin, mlout, dbcmd, @extract_topic, @collection)
          redirect_to extract_topics_path
        else
          flash[:error] = "Could not save process topic model"
          redirect_to new_extract_topic_path
        end
      end
    end
  end

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
    @extract.destroy
    respond_to do |format|
      format.html { redirect_to extract_topics_path }
      #   format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_extract
    @extract = ExtractTopic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def extract_topic_params
   params.require(:extract_topic).permit(
      :lda, :num_of_topics, :routine_name, :collection_id,
      :preprocess_id, :status, :fname_base, :file_dir
    )
  end
end
