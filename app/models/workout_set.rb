class WorkoutSet < ApplicationRecord
  belongs_to :workout_instance
  has_one :workout, through: :workout_instance
  has_one :workout_session, through: :workout_instance
  before_validation :update_all_units
  validates :reps, presence: true, inclusion: { in: 1..5000 }, numericality: { only_integer: true }

  validates :amount_imp, presence: true, numericality: { greater_than: 0.01, less_than_or_equal_to: 15000 }
  validates :amount_metric, presence: true, numericality: { greater_than: 0.01, less_than_or_equal_to: 15000 }

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
