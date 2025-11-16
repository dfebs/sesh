class AddTimeZoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :time_zone, :string, default: "America/New York", null: false
  end
end
