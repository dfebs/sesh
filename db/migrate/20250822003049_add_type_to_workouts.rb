class AddTypeToWorkouts < ActiveRecord::Migration[8.0]
  def change
    add_column :workouts, :workout_type, :string, null: false
  end
end
