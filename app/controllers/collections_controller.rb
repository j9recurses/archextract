class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
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
    mycollection, myreturn = Collection.parse_collection_params(collection_params, params)
    if myreturn
      @collection = Collection.new(mycollection)
      if @collection.save
        pp = Collection.add_preprocess(@collection)
        if pp
          flash[:notice] =  'Collection successfully saved'
          redirect_to @collection
        else
          flash[:error] = "Error: Could not save collection- problem with saving intital preprocess"
          redirect_to new_collection_path
        end
      else
        flash[:error] = "Error: Could not save collection"
        redirect_to new_collection_path
      end
    else
      flash[:error] =  mycollection
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
