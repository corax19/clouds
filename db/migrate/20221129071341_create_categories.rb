class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.string :status
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
