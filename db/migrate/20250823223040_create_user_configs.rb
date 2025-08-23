class CreateUserConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :user_configs do |t|
      t.string :short_distance_unit
      t.string :long_distance_unit
      t.string :weight_unit
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
