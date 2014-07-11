class CreatePreProcess < ActiveRecord::Migration
  def change
    create_table :preprocesses do |t|
      t.boolean :stopwords
      t.boolean :rarewords
      t.boolean :stemmed
      t.boolean :tagged
      t.string :pos
      t.boolean :tagged_no_ner
      t.boolean :tfidf
      t.string :custom_stoplist
    end
  end
end
