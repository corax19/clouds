class CreateHotlines < ActiveRecord::Migration[7.0]
  def change
    create_table :hotlines do |t|
      t.string :name
      t.string :title
      t.text :strategy
      t.integer :timeout
      t.integer :retry
      t.integer :wrapuptime
      t.integer :maxlen

      t.timestamps
    end
  end
end
