class AddVmToExten4 < ActiveRecord::Migration[7.0]
  def change
remove_column :extens, :voicemail_id, :integer
  end
end
