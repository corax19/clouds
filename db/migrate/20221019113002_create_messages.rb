class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :from, :default => 'System'
      t.string :type, :default => 'Info'
      t.text :message
      t.integer :read, :default => 0
      t.timestamps
    end
add_reference :messages, :account, null: false, foreign_key: true

  end
end
