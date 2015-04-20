class AddextractNerIdToNers < ActiveRecord::Migration
  def change
         add_reference :ners, :extract_ner, index: true
  end
end
