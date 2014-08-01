class AddTopicNumberToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :topic_number, :string
  end
end
