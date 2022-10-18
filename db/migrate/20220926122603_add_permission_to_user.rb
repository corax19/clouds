class AddPermissionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :permission, :string
  end
end
