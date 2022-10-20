class AddMohToQueue < ActiveRecord::Migration[7.0]
  def change
   add_reference :hotlines, :moh, null: true
  end
end
