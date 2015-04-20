class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :collectin_id
      t.string :collection_name
      t.date :acquisition_date
      t.string :acquisition_source
      t.date :start_date
      t.date :end_date
      t.string :src_datadir
      t.text :notes

      t.timestamps
    end
  end
end
