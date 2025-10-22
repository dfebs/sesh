class WorkoutInstance < ApplicationRecord
  belongs_to :workout_session
  belongs_to :workout

  has_many :workout_sets, dependent: :destroy

  def volume
    workout_sets.sum { |set| set.amount * set.reps }
  end

  def name
    workout.name
  end

  def user
    workout_session.user
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
