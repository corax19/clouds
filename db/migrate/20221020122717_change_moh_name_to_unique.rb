class ChangeMohNameToUnique < ActiveRecord::Migration[7.0]
  def change
   add_index :mohs, [:account_id, :name], unique: true
  end
end
