class ChangeTypesToHours < ActiveRecord::Migration[7.0]
  def change
  change_column :routes, :hourstart, :integer, :default => '0', :null => false
  change_column :routes, :hourstop, :integer, :default => '23', :null => false

  end
end
