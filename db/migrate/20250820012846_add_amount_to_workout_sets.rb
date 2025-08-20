class AddAmountToWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sets, :amount, :integer, null: false
  end
end
