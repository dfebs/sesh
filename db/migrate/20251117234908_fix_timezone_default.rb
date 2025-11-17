class FixTimezoneDefault < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :time_zone, from: "America/New York", to: "America/New_York"
  end
end
