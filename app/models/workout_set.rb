class WorkoutSet < ApplicationRecord
  belongs_to :workout_instance
  has_one :workout, through: :workout_instance
  has_one :workout_session, through: :workout_instance
  before_validation :update_all_units

  def preferred_unit
    config = workout.author.user_config
    config.get_unit workout.workout_type
  end

  def amount
    case Constants::UNIT_TYPES[preferred_unit]
    when "imperial"
      amount_imp
    when "metric"
      amount_metric
    end
  end

  def update_all_units
    case Constants::UNIT_TYPES[preferred_unit]
    when "imperial"
      self.amount_metric = self.amount_imp * Constants::UNIT_CONVERSION_FACTORS[preferred_unit]

    when "metric"
      self.amount_imp = self.amount_metric * Constants::UNIT_CONVERSION_FACTORS[preferred_unit]
    end
  end
end
