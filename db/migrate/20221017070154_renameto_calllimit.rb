class RenametoCalllimit < ActiveRecord::Migration[7.0]
  def change
  rename_column :extens, :number, :calllimit
  end
end
