class ChangeColumnTypeQueueNew < ActiveRecord::Migration[7.0]
  def change
change_column(:hotlines, :strategy, :string)
  end
end
