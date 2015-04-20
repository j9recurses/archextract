class AddProcessedToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :is_processed, :boolean, :null => false, :default => false
  end
end
