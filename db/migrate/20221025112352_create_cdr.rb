class CreateCdr < ActiveRecord::Migration[7.0]
  def change
    create_table :cdrs do |t|
    t.timestamps
    end


  end
end
