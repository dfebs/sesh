class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.string :name
      t.string :description
      t.references :author, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.timestamps
    end
  end
end
