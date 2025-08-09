class CreateWorkoutInstances < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_instances do |t|
      t.references :workout_session, null: false, foreign_key: { on_delete: :cascade }
      t.references :workout_template, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
