class AddSlugsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :slug, :string, :unique => true
    add_index :documents, :slug
  end
end
