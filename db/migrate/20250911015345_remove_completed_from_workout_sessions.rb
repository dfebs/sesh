class RemoveCompletedFromWorkoutSessions < ActiveRecord::Migration[8.0]
  def change
    remove_column :workout_sessions, :completed, :boolean
  end
end
