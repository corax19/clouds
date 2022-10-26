class CdrChange2 < ActiveRecord::Migration[7.0]
  def change
change_column :cdrs, :updated_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
  end
end
