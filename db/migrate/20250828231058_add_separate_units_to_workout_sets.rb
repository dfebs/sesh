class AddSeparateUnitsToWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sets, :amount_imp, :float, null: false
    add_column :workout_sets, :amount_metric, :float, null: false
  end
end
