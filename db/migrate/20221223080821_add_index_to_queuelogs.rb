class AddIndexToQueuelogs < ActiveRecord::Migration[7.0]
  def change
   add_index :queuelogs, [:callid]
  end
end
