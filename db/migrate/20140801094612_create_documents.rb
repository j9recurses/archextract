class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :file_dir
      t.timestamps
    end
    add_reference :documents, :collection, index: true
  end
end
