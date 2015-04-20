class RemoveStartDateFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :start_date, :date
    remove_column :collections, :end_date, :date
  end
end
