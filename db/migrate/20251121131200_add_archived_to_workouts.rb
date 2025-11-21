class AddArchivedToWorkouts < ActiveRecord::Migration[8.0]
  def change
    add_column :workouts, :archived, :boolean, null: false, default: false
  end
end
