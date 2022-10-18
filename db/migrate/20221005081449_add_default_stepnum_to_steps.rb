class AddDefaultStepnumToSteps < ActiveRecord::Migration[7.0]
  def change
change_column :steps, :stepnum, :integer, :default => '9999'
  end
end
