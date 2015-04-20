class AddColumnsToExtractTopics < ActiveRecord::Migration
  def change
     add_column :extract_topics, :status, :string
     add_column :extract_topics, :fname_base, :string
     add_column :extract_topics, :file_dir, :string
  end
    add_reference :extract_topics, :preprocess
    add_index(:extract_topics, :preprocess_id, :unique => true)
end
