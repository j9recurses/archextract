class AddTimestampsToPreprocesses < ActiveRecord::Migration
  def change
      add_column(:preprocesses, :created_at, :datetime)
      add_column(:preprocesses, :updated_at, :datetime)
  end
end
