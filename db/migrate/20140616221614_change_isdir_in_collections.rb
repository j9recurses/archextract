class ChangeIsdirInCollections < ActiveRecord::Migration
  def change
  	change_column :collections, :isdir, :boolean  
  end
end
