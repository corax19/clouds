class AddQueueLogIndexes < ActiveRecord::Migration[7.0]
  def change
add_index :queuelogs, :time
add_index :queuelogs, [:time, :queuename]
add_index :queuelogs, [:time, :agent]

  end
end
