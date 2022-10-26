class AddToAgents < ActiveRecord::Migration[7.0]
  def change
    add_column :agents, :name, :string
    add_column :agents, :membername, :string
    add_column :agents, :queue_name, :string
    add_column :agents, :interface, :string
    add_column :agents, :paused, :integer, :default =>  0

  end
end
