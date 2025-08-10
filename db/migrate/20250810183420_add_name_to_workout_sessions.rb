class AddNameToWorkoutSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sessions, :name, :string, null: false
  end
end
