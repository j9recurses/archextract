class AddStatusToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :status, :string
  end
end
