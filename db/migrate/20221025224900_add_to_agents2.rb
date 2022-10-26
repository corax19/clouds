class AddToAgents2 < ActiveRecord::Migration[7.0]
  def change
add_column :agents, :uniqueid, :integer
  end
end
