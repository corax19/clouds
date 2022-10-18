class ChangeTypesToDays < ActiveRecord::Migration[7.0]
  def change
  change_column :routes, :daystart, :string, :default => 'mon', :null => false
  change_column :routes, :daystop, :string, :default => 'sun', :null => false
  end
end
