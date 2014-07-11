class CreatePreassignment < ActiveRecord::Migration
  def change
    create_table :preassignments do |t|
      t.integer :collection_id
      t.integer :preprocesses_id
    end
    add_index :preassignments, :collection_id
    add_index :preassignments, :preprocesses_id
  end
end
