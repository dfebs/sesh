class Workout < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :workout_instances, dependent: :destroy
  has_many :workout_sets, through: :workout_instances

  def highest_volume
    workout_instances.max_by(&:volume)&.volume || 0
  end

  def unit
    author.user_config.get_unit workout_type
  end
end
