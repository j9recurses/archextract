class AddRoutineNameToPreprocesses < ActiveRecord::Migration
  def change
    add_column :preprocesses, :routine_name, :string
  end
end
