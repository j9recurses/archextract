class AddOrigUploadFnToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :orig_upload_fn, :string
  end
end
