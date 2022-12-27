class AddIndexToAccounts < ActiveRecord::Migration[7.0]
  def change
   add_index :accounts, [:token]
  end
end
