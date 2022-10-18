class AddAccountRouteToStep < ActiveRecord::Migration[7.0]
  def change
   add_reference :steps, :account, null: false, foreign_key: true
   add_reference :steps, :route, null: false, foreign_key: true
  end
end
