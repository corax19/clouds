class CdrChange < ActiveRecord::Migration[7.0]
  def change
change_column :cdrs, :created_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
  end
end
