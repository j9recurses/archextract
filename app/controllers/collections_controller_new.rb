class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    session[:collection_id] = @collection[:id]
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json

  def create
    ip  =  CollectionImportOpts.new()
    chk, @create_error =   ip.make_collection(collection_params)
    if chk
      @collection = Collection.new( collection_params.reject!{ |k| k == :src_datadir} )
      @collection[:status] = "Processing"
       if @collection.save
          flash[:notice] =  "Thank you for your submission. We are attempting to import the " +  @collection[:name] + " You will be sent an email when the job is done."
          Delayed::Job.enqueue CollectionImport.new(@collection, collection_params, params)
          redirect_to @collection
          session[:collection] = @collection
      else
        flash[:error] = "Error: Could not save collection-please try uploading the collection again later."
        redirect_to new_collection_path
      end
   else
       flash[:error]  = @create_error
        redirect_to new_collection_path
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    if @collection.update(collection_params)
      flash[:notice] = 'Collection was successfully updated.'
      redirect_to @collection
    else
      flash[:notice] = @collection.errors
      render action: 'edit'
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    removed_files = Collection.destroy_input_files_and_dirs(params)
    if removed_files
      @collection.destroy
      respond_to do |format|
        flash[:notice] = 'Collection was successfully deleted.'
        format.html { redirect_to collections_url }
        format.json { head :no_content }
      end
    else
      flash[:error] = 'Error! Could not delete the collection.'
      redirect_to collections_url
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(
      :name,
      "acquisition_date(1i)",
      "acquisition_date(2i)",
      "acquisition_date(3i)",
      :acquisition_source,
      :src_datadir,
      :isdir,
      :notes,
      :is_processed,
      :mimetype,
      :filesize,
      :file_ext
    )
  end
end
