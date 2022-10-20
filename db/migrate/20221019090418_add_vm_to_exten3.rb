class AddVmToExten3 < ActiveRecord::Migration[7.0]
  def change
remove_foreign_key :extens, :voicemails
  end
end
