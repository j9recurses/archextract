class AddStatusToPreprocess < ActiveRecord::Migration
  def change
    add_column :preprocesses, :status, :string
  end
end
