class ChangeCollectioName < ActiveRecord::Migration
  def change
    add_column :collections, :lib_path, :string
    remove_column :collections, :file_ext, :string
    remove_column :collections, :isdir, :boolean
    remove_column :collections, :filesize, :integer
    remove_column :collections, :mimetype , :string
    remove_column :collections, :orig_upload_fn, :string
  end
end
