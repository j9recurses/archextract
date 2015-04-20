class AddtfidfOptsToPreprocesses < ActiveRecord::Migration
  def change
      add_column(:preprocesses, :tfidf_btm, :boolean)
      add_column(:preprocesses, :tfidf_score, :decimal)
  end
end
