class UsersChangeColumnType < ActiveRecord::Migration[7.0]
  def change
  change_column(:users, :permission, :text)
  end
end
