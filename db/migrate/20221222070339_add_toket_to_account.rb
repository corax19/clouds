class AddToketToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :token, :string, :default => ''
  end
end
