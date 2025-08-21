class RemoveUnitFromWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    remove_column(:workout_sets, :unit)
  end
end
