class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone1
      t.string :phone2
      t.string :phone3
      t.string :idnum
      t.string :country
      t.string :city
      t.string :address
      t.string :email
      t.date :birthday
      t.timestamps
    end
  end
end
