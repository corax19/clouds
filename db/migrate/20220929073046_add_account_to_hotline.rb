class AddAccountToHotline < ActiveRecord::Migration[7.0]
  def change
    add_reference :hotlines, :account, null: false, foreign_key: true
  end
end
