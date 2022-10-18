class AddAccountKeyToRoute < ActiveRecord::Migration[7.0]
  def change
   add_reference :routes, :account, null: false, foreign_key: true
  end
end
