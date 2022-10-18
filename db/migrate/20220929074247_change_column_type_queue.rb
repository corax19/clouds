class ChangeColumnTypeQueue < ActiveRecord::Migration[7.0]
  def change
  change_column(:hotlines, :strategy, :integer)
  end
end
