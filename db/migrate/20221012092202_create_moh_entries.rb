class CreateMohEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :moh_entries do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :moh, null: false, foreign_key: true
      t.belongs_to :sound, null: false, foreign_key: true
      t.timestamps
    end
  end
end
