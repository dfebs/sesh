class AddOrderIndexToWorkoutInstances < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_instances, :order_index, :float
  end
end
