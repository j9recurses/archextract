class AddBelongsToPreprocesses < ActiveRecord::Migration
  def change
    add_reference :preprocesses, :collection, index: true
  end
end
