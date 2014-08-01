class CreateDocTopics < ActiveRecord::Migration
 def change
    create_table :topic_docs, :id => false do |t|
      t.text :name
      t.text :topics
      t.text :topic_vals
      t.integer :dcid
    end
  add_reference :topic_docs, :collection, index: true
  add_reference :topic_docs, :preprocess, index: true
  add_reference :topic_docs,  :extract_topic, index: true
  add_index :topic_docs, :dcid
  end
end
