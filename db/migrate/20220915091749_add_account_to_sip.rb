class AddAccountToSip < ActiveRecord::Migration[7.0]
  def change
    add_reference :sips, :account, null: false, foreign_key: true
  end
end
