class AddFiledirToPreprocesses < ActiveRecord::Migration
  def change
    add_column :preprocesses, :fname_base, :string
    add_column :preprocesses, :file_dir, :string
  end
end
