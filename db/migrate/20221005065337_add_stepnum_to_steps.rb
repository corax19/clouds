class AddStepnumToSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :steps, :stepnum, :integer
  end
end
