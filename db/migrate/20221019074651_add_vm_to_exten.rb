class AddVmToExten < ActiveRecord::Migration[7.0]
  def change
  add_reference :extens, :voicemail
#, index: { name: "voicemail_uniqueid", using: 'uniqueid' }, null: false, foreign_key: true

#   add_reference :extens, :voicemails, null: true, foreign_key:  true
#    add_reference :extens, :voicemail
#    add_foreign_key :extens, :voicemail, column: :uniqueid
  end
end
