class ModifyLogs < ActiveRecord::Migration[7.0]
  def change
   add_index :logs, :created_at
   add_column :logs, :url, :string
  end
end
