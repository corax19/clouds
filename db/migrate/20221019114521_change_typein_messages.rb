class ChangeTypeinMessages < ActiveRecord::Migration[7.0]
  def change
remove_column :messages, :type, :string
add_column :messages, :messagetype, :string, :default => 'Info'
  end
end
