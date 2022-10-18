class AddAccountToMoh < ActiveRecord::Migration[7.0]
  def change
  add_reference :mohs, :account, null: false, foreign_key: true
  end
end
