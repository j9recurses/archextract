class CreateExtractNers < ActiveRecord::Migration
  def change
    create_table :extract_ners do |t|
      t.string :status
      t.string :fname_base
      t.string :file_dir
      t.string :status
      t.boolean :ner_peeps
      t.boolean :ner_places
      t.boolean :ner_orgs
      t.boolean :ner_dates
      t.timestamps
    end
       add_reference :extract_ners, :collection, index: true
  end
end
