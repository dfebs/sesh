class AddTitleToWorkoutSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_sessions, :title, :string, null: false
  end
end
