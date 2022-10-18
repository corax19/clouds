class AddNumberToRoute < ActiveRecord::Migration[7.0]
  def change
   add_reference :routes, :sip, null: false, foreign_key: true
  end
end
