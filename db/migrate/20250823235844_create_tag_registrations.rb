class CreateTagRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :tag_registrations do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :workout, null: false, foreign_key: true

      t.timestamps
    end
  end
end
