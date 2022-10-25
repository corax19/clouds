class AddToCdr2 < ActiveRecord::Migration[7.0]
  def change
add_index :cdrs, :accountcode
add_index :cdrs, :created_at
add_index :cdrs, [:accountcode, :created_at]
  end
end
