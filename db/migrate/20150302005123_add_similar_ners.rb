class AddSimilarNers < ActiveRecord::Migration
  def change
    add_column :ners, :sm_items, :text
    add_column :ners, :sm_ct, :integer
  end
end


