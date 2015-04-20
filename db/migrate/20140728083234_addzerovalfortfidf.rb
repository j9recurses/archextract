class Addzerovalfortfidf < ActiveRecord::Migration
  def change
    change_column :preprocesses, :tfidf_score, :float, :null => true
  end
end
