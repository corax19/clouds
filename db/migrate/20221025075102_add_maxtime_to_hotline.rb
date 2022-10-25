class AddMaxtimeToHotline < ActiveRecord::Migration[7.0]
  def change
  add_column :hotlines, :maxtime, :integer, :default => 0
  end
end
