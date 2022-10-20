class AddVmToExten2 < ActiveRecord::Migration[7.0]
  def change
  change_column :extens, :voicemail_id, :integer
  add_foreign_key :extens, :voicemails, column: :voicemail_id, primary_key: "uniqueid"
  end
end
