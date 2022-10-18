class ModifyLogs2 < ActiveRecord::Migration[7.0]
  def change
  add_column :logs, :ipaddr, :string
  end
end
