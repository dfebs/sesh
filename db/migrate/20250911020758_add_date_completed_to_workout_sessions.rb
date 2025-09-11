class AddDateCompletedToWorkoutSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sessions, :date_completed, :date
  end
end
