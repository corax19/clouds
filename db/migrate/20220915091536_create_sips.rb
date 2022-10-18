class CreateSips < ActiveRecord::Migration[7.0]
  def change
    create_table :sips do |t|
      t.string :sipid
      t.string :secret
      t.string :host
      t.string :number
      t.string :decription

      t.timestamps
    end
  end
end
