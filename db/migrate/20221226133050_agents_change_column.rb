class AgentsChangeColumn < ActiveRecord::Migration[7.0]
  def change
rename_column :agents, :priority, :penalty
  end
end
