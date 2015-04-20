class AddCollectionIdToNers < ActiveRecord::Migration
  def change
     add_reference :ners, :collection, index: true
  end
end
