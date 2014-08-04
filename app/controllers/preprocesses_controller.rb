class PreprocessesController < ApplicationController
  before_filter :get_collection
  before_action :set_preprocess, only: [:show, :edit, :update, :destroy]

  def get_collection
    @collection =  Collection.find(params[:collection_id])
    session[:collection_id] = @collection[:id]
  end


  # GET /preprocesses
  def index
    @preprocesses = @collection.preprocesses.where.not(routine_name: "plain text")
  end

  # GET /preprocesses/1
  def show
    puts params
  end

  # GET /preprocesses/new
  def new
    @preprocess = Preprocess.new
  end

  # GET /preprocesses/1/edit
  def edit
  end

  # POST /preprocesses
  def create
    pp = Preprocesscollectionopts.new(preprocess_params, @collection )
    @preprocess, @error = pp.get_preprocess_stem_tag_cmd_short
    pp_exists, pp_error = pp.preprocess_exists?(@preprocess, @collection)
    if pp_exists
      puts pp_error
      flash[:error] =  pp_error
      redirect_to new_collection_preprocess_path(@collection[:id])
    else
      if @error.present?
        flash[:message] =  @error
        redirect_to new_collection_preprocess_path(@collection[:id])
      else
        @preprocess[:status] = "processing"
        @preprocess = Preprocess.new(@preprocess)
        if @preprocess.save
          flash[:notice] =  'Thank you for your submission: The Pre-Process job for the '+  @collection[:name] + ' is now running. You will be sent an email when the job is done.'
          Delayed::Job.enqueue Preprocesscollection.new(preprocess_params, params[:collection_id], @preprocess )
          redirect_to collection_preprocesses_path
        else
          flash[:error] =  'Error: Your Preprocess routine for the ' + @collection[:name] + ' could not be completed!'
          redirect_to collection_preprocesses_path
        end
      end
    end
  end

  def create_notnow
    pp = Preprocesscollectionopts.new(preprocess_params, @collection )
    @preprocess = pp.get_preprocess_stem_tag_cmd_short
    if pp.check_if_preprocess_exists?
      flash[:error] =  'Error: Your Preprocess routine for the ' + @collection[:name] + 'already exists!'
      redirect_to collection_preprocessespath
    else
      @preprocess[:status] = "processing"
      @preprocess = Preprocess.new(@preprocess)
      if @preprocess.save
        flash[:notice] =  'Thank you for your submission: The Pre-Process job for the '+  @collection[:name] + ' Collection is now running. You will be sent an email when the job is done.'
        Delayed::Job.enqueue Preprocesscollection.new(preprocess_params, params[:collection_id], @preprocess )
        redirect_to collection_preprocesses_path
      else
        flash[:error] =  'Error: Your Preprocess routine for the ' + @collection[:name] + ' could not be completed!'
        redirect_to collection_preprocesses_path
      end
    end
  end

  # DELETE /preprocesses/1
  # DELETE /preprocesses/1.json
  def destroy
    flash[:notice] = "The  " + @collection[:name] + " Collection is being deleted. An email will be sent when this job is done."
    cool = Delayed::Job.enqueue Deletepreprocess.new(@preprocess[:id])
    puts cool
    redirect_to collection_preprocesses_path
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
      :collection_id,
      :id,
      :status,
      :tfidf_btm,
      :tfidf_score,
      :pos => []
    ).merge(id: params[:id], collection_id: params[:collection_id])
  end
end
