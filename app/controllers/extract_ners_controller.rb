class ExtractNersController < ApplicationController
  before_action :set_extract_ner, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!


  # GET /extract_ners
  def index
    @extract_ners = ExtractNer.joins(:collection).select( 'extract_ners.collection_id', 'collections.name',
    'extract_ners.id', 'extract_ners.status' )
    #@collection = Collection.find(@extract_ners[:collection_id])
  end

  # GET /extract_ners/1
  def show
  end

  # GET /extract_ners/new
  def new
    @extract_ner = ExtractNer.new
    @collections = Collection.all
    @collections_array = {}.tap{ |h|  @collections.each{ |c| h[c.name] = c.id } }
  end

  # GET /extract_ners/1/edit
  def edit
  end

  # POST /extract_ners
  # POST /extract_ners.json
  def create
    nr =  ExtractNerOpts.new(@collection, extract_ner_params )
    ners,  @extract_ner  =  nr.chk_if_ners_exist
    if ners
      @extract_ner = ExtractNer.new(@extract_ner )
       if @extract_ner.save
        flash[:notice]  = 'Thank you for your submission: The Topic Model job for the '+  @collection[:name] + ' is now running. You will be sent an email when the job is done.'
        server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job = nr.make_cmdlines(@extract_ner[:id])
        Delayed::Job.enqueue ExtractNerRunJob.new( server_cmd, ner_infile_cmds, ner_mr_job, load_ners_job , @collection, @extract_ner)
        redirect_to collection_extract_ners_path(@collection[:id])
      else
        flash[:error] = "Could not save Named Entities Job"
        redirect_to collection_extract_ners_path(@collection[:id])
      end
     else
        flash[:error] = "Error: Named Entities for the collection already exist"
        redirect_to collection_extract_ners_path(@collection[:id])
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
        redirect_to collection_extract_ners_path(@collection[:id])
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
