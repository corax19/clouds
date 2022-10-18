class AddFieldsToExtens < ActiveRecord::Migration[7.0]
  def change
    add_column :extens, :number, :integer, :default => 1
    add_column :extens, :record, :string, :default => 'No'
  end
end
