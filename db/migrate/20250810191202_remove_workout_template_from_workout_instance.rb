class RemoveWorkoutTemplateFromWorkoutInstance < ActiveRecord::Migration[8.0]
  def change
    change_table :workout_instances do |t|
      t.remove_foreign_key :workout_templates
      t.references :workout, null: false, foreign_key: { on_delete: :cascade }
    end
  end
end
