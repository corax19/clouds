class RemoveFieldsFromRoutes < ActiveRecord::Migration[7.0]
  def change
    remove_column :routes, :number, :integer
    remove_column :routes, :account, :integer
  end
end
