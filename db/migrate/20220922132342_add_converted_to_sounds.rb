class AddConvertedToSounds < ActiveRecord::Migration[7.0]
  def change
    add_column :sounds, :converted, :integer, :default => 0
  end
end
