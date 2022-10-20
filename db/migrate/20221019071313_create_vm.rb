class CreateVm < ActiveRecord::Migration[7.0]
  def change
    create_table :voicemails, id: false do |t|
      t.integer :uniqueid, auto_increment: true, primary_key: true
      t.string :context, :default => ''
      t.integer :mailbox, :default => '0'
      t.string :password, :default => '9999'
      t.string :fullname, :default => '0'
      t.string :email, :default => ''
      t.string :pager, :default => ''
      t.datetime :stamp, :default => 'No'
      t.string :attach, :default => 'No'
      t.string :saycid, :default => 'Yes'
      t.string :hidefromdir, :default => 'No'
      t.timestamps
    end

      add_reference :voicemails, :exten, null: false, foreign_key: true

  end
end
