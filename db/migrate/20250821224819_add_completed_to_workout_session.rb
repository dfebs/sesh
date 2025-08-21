class AddCompletedToWorkoutSession < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sessions, :completed, :boolean, default: false, null: false
  end
end
