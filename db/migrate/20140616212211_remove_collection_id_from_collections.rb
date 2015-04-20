class RemoveCollectionIdFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :collectin_id, :int
  end
end
