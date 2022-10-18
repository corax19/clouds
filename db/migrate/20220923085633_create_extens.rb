class CreateExtens < ActiveRecord::Migration[7.0]
  def change
    create_table :extens do |t|
      t.string :exten
      t.string :secret
      t.string :name
      t.string :decription
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :sip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
