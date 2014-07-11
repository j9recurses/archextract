class ChangeColumnCollectonName < ActiveRecord::Migration
  def change
	rename_column :collections, :collection_name, :name
  end
end
