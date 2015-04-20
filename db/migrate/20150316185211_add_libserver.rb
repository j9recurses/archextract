class AddLibserver < ActiveRecord::Migration
  def change
    add_column :collections, :libserver, :string
  end
end
