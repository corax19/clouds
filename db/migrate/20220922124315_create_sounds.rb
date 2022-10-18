class CreateSounds < ActiveRecord::Migration[7.0]
  def change
    create_table :sounds do |t|
      t.string :name
      t.string :audio
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
