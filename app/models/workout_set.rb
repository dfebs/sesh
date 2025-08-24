class WorkoutSet < ApplicationRecord
  belongs_to :workout_instance
  has_one :workout, through: :workout_instance

  def unit
    config = Current.user.user_config
    config.get_unit self.workout[:workout_type]
  end
end
