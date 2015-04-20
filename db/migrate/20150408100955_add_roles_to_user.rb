class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :archivist, :boolean
    add_column :users, :researcher, :boolean
  end
end
