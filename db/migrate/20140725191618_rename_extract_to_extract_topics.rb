class RenameExtractToExtractTopics < ActiveRecord::Migration
  def change
    rename_table :extracts, :extract_topics
  end
end
