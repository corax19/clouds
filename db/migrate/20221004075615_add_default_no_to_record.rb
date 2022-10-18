class AddDefaultNoToRecord < ActiveRecord::Migration[7.0]
  def change
    change_column :routes, :record, :string, :default => 'No', :null => false
  end
end
