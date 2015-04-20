class AddKeywordstoExtractNers < ActiveRecord::Migration
  def change
    add_column :extract_ners, :keywords, :boolean
  end
end
