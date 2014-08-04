class CreateNers < ActiveRecord::Migration
  def change
    create_table :ners do |t|
      t.string :nertype
      t.string :name
      t.text  :docs
      t.integer :count
      t.timestamps
    end
  end
end
