class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
