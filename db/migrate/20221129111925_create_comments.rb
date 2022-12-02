class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :callid
      t.string :status
      t.integer :category_id
      t.integer :user_id
      t.text :body
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
