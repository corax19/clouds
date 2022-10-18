class CreateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :agents do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :hotline, null: false, foreign_key: true
      t.belongs_to :exten, null: false, foreign_key: true
      t.integer :priority

      t.timestamps
    end
  end
end
