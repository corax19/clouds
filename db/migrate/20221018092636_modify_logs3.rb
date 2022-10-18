class ModifyLogs3 < ActiveRecord::Migration[7.0]
  def change
add_index :logs, :created_at
  end
end
