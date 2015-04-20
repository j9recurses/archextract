class AddMimetypeToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :mimetype, :string
    add_column :collections, :filesize, :integer
    add_column :collections, :file_ext, :string
  end
end
