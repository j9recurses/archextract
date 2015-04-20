class Addfiletypetodocuments < ActiveRecord::Migration
  def change
    add_column :documents, :filetype, :string
    add_column :documents, :downloaded, :boolean
  end
end
