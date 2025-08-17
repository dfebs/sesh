class AddUnitToWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sets, :unit, :string, null: false
  end
end
