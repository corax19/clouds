class AddQueueLog < ActiveRecord::Migration[7.0]
  def change
  create_table :queuelogs do |t|
      t.datetime :time
      t.string :callid
      t.string :queuename
      t.string :agent
      t.string :event
      t.string :data
      t.string :data1
      t.string :data2
      t.string :data3
      t.string :data4
      t.string :data5
      t.integer :created,:default => Time.now
  end
  end
end


