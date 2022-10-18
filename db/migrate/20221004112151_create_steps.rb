class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.string :event
      t.text :data

      t.timestamps
    end
  end
end
