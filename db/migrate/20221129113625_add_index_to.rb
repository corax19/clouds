class AddIndexTo < ActiveRecord::Migration[7.0]
  def change
   add_index :comments, [:callid]
  end
end
