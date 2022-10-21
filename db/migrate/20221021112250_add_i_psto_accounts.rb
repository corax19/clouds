class AddIPstoAccounts < ActiveRecord::Migration[7.0]
  def change
add_column :accounts, :sipips, :text
add_column :accounts, :webips, :text
  end
end
