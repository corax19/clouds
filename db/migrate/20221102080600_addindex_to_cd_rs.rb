class AddindexToCdRs < ActiveRecord::Migration[7.0]
  def change
add_index :cdrs, [:accountcode, :start]
  end
end
