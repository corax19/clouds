class CreateMohs < ActiveRecord::Migration[7.0]
  def change
    create_table :mohs do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
