class CreateTopics < ActiveRecord::Migration
 def change
    create_table :topics, :id => false do |t|
      t.text :name
      t.text :docs
      t.text :doc_vals
      t.integer :tid
      t.timestamps
    end
  add_reference :topics, :collection, index: true
  add_reference :topics, :preprocess, index: true
  add_reference :topics, :extract_topic, index: true
  add_index :topics, :tid
  end
end
