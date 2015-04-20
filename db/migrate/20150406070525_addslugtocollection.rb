class Addslugtocollection < ActiveRecord::Migration
  def change
    add_column :collections, :slug, :string, :unique => true
    add_index :collections, :slug
  end
end
