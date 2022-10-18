class CreateRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :routes do |t|
      t.integer :number
      t.string :name
      t.string :record
      t.integer :account
      t.date :day
      t.integer :daystart
      t.integer :daystop
      t.integer :hourstart
      t.integer :hourstop

      t.timestamps
    end
  end
end
