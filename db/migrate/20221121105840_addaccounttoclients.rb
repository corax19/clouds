class Addaccounttoclients < ActiveRecord::Migration[7.0]
  def change
  add_reference :clients, :account, null: false, foreign_key: true
  add_index :clients, [:account_id, :phone1]
  add_index :clients, [:account_id, :phone2]
  add_index :clients, [:account_id, :phone3]
  end
end
