class CreateWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_sets do |t|
      t.integer :reps, null: false
      t.references :workout_instance, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
