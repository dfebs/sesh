class RemoveWorkoutTemplateFromWorkoutInstances < ActiveRecord::Migration[8.0]
  def change
    remove_reference :workout_instances, :workout_template
  end
end
