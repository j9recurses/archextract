class CreateExtracts < ActiveRecord::Migration
  def change
    create_table :extracts do |t|
      t.boolean :lda
      t.integer :num_of_topics
      t.string :routine_name
      t.timestamps
    end
    add_reference :extracts, :collection, index: true
  end
end
