class AddIsadminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :isadmin, :integer, default: false
  end
end
