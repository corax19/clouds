class ChangeSoundNameToTables < ActiveRecord::Migration[7.0]
  def change
add_index :hotlines, [:account_id, :title], unique: true
add_index :sips, [:account_id, :sipid], unique: true
add_index :sips, [:account_id, :number], unique: true
add_index :extens, [:account_id, :exten], unique: true

  end
end
