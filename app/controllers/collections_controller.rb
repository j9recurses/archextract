class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :except => [:index, :show]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    session[:collection_id] = @collection[:id]
    @collection = Collection.friendly.find(params[:id])
    #@collection_size = Document.where('colleciton_id', @collection[:id).count
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
    #start off the queue rake jobs:work
    #mycollection, myreturn = Collection.parse_collection_params(collection_params, params)
   puts collection_params.inspect
   puts "here"
    @collection = Collection.new(collection_params)
    puts @collection.inspect
    @collection[:src_datadir] = collection_params[:name].gsub(/\s+/, "_")
    @collection[:status] = 'uploading files'
    if @collection.save()
      flash[:notice]  = 'Thank you for your submission. We are obtaining the collection documents for '+  @collection[:name] + ' collection. You will be sent an email when the job is done.'
      Delayed::Job.enqueue CollectionImport.new(@collection)
      redirect_to collections_path
    else
        flash[:error] = "Error: Could not save collection"
        render action: 'new'
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
    @collection = Collection.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(
      :name,
      :acquisition_source,
      "acquisition_date(1i)",
      "acquisition_date(2i)",
      "acquisition_date(3i)",
      :src_datadir,
      :lib_path,
      :libserver,
      :notes,
      :is_processed,
      :slug,
      :acquisition_date,
      :status)
  end
end
