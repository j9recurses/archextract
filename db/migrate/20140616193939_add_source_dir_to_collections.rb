class AddSourceDirToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :isdir, :boolean
  end
end
