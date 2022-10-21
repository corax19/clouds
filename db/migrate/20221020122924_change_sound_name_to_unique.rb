class ChangeSoundNameToUnique < ActiveRecord::Migration[7.0]
  def change
add_index :sounds, [:account_id, :name], unique: true
  end
end
