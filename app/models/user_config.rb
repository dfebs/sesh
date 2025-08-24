class UserConfig < ApplicationRecord
  belongs_to :user

  def get_unit (workout_type)
    units = {
      "Weight" => self.weight_unit,
      "Long Distance" => self.long_distance_unit,
      "Short Distance" => self.short_distance_unit
    }

    units[workout_type]
  end
end
