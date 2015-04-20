class Removepreprocessindexfromextracttopics < ActiveRecord::Migration
  def change
    remove_index(:extract_topics,:preprocess_id)
    add_index(:extract_topics, :preprocess_id)
  end
end
