class Maketables < ActiveRecord::Migration
  def change
    create_table :topic_names do |t|
      t.text :name
    end

    create_table :topic_doc_names do |t|
      t.text :name
    end

    create_table :topics, :id => false do |t|
      t.text :name
      t.text :docs
      t.text :doc_vals
      t.integer :tid
      t.string :topic_number
      t.timestamps
    end

    create_table :topic_docs, :id => false do |t|
      t.string :name
      t.text :topics
      t.text :topic_vals
     t.integer :dcid
      t.timestamps
      end

  add_reference :topic_docs, :collection, index: true
  add_reference :topic_docs, :preprocess, index: true
  add_reference :topic_docs,  :extract_topic, index: true
  add_reference :topic_docs,  :doc_topic_names, index: true
    add_reference :topics, :collection, index: true
  add_reference :topics, :preprocess, index: true
  add_reference :topics, :extract_topic, index: true
  add_reference :topics, :topic_names, index: true
  change_column :topics, :docs, :text, :limit => 4294967295
    change_column :topics, :doc_vals, :text, :limit => 4294967295
      change_column :topic_docs, :topics, :text, :limit => 4294967295
     change_column :topic_docs, :topic_vals, :text, :limit => 4294967295

  end
end
