class AddCallIdToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :callid, :string
    add_index :notes, [:callid]
  end
end
