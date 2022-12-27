class AddBlacklistToClients < ActiveRecord::Migration[7.0]
  def change
     add_column :clients, :blacklist, :string, :default => 'No'
  end
end
