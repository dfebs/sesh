class WorkoutInstance < ApplicationRecord
  belongs_to :workout_session
  belongs_to :workout

  after_validation :set_order_index
  has_many :workout_sets, dependent: :destroy
  validate :check_max_instances, on: :create

  def volume
    workout_sets.sum { |set| set.amount * set.reps }
  end

  def highest_attempt
    workout_sets.max_by(&:amount).amount
  end

  def name
    workout.name
  end

  def user
    workout_session.user
  end
  
  def check_max_instances
    max = 20
    if workout_session.workout_instances.length > max
      errors.add :base, "Max number of workout sessions reached. Max is #{max}."
    end
  end

  def set_order_index
    last_index = workout_session.workout_instances.order_by(:order_index).last.order_index
    self.order_index = (last_index + 100.0) / 2.0
  end

  def self.dup_workout_sets(origin, receiver)
    sets = origin.workout_sets.map(&:dup)
    sets.each do |set|
      set.workout_instance = receiver
    end
    sets
  end

  def self.highest_volume (user, workout_instance)
    user_workout_instances = WorkoutInstance.where(workout: workout_instance.workout).select { |instance| instance.user == user }
    user_workout_instances.max { |a, b| a.volume <=> b.volume }
  end
end
