class RemoveAmountFromWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    remove_column :workout_sets, :amount, :integer
  end
end
