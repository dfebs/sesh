class AddUnitToWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sets, :unit, :string
  end
end
