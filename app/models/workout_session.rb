class WorkoutSession < ApplicationRecord
  belongs_to :user
  has_many :workout_instances, dependent: :destroy
  has_many :workout_sets, through: :workout_instances
  validates :title, presence: true
  validates_size_of :title, within: 1..50

  def completed?
    date_completed.present?
  end

  def ready_for_completion?
    if workout_instances.length == 0
      return false
    end

    workout_instances.each do |workout_instance|
      if workout_instance.workout_sets.length == 0
        return false
      end
    end

    true
  end

  def deep_duplicate
    workout_session_dup = self.dup

    ActiveRecord::Base.transaction do
      workout_session_dup.date_completed = nil
      workout_session_dup.save!

      workout_instances.each do |workout_instance|
        workout_instance_dup = workout_instance.dup
        workout_instance_dup.workout = workout_instance.workout
        workout_instance_dup.workout_session = workout_session_dup
        workout_instance_dup.save!

        workout_instance.workout_sets.each do |workout_set|
          workout_set_dup = workout_set.dup
          workout_set_dup.workout_instance = workout_instance_dup
          workout_set_dup.save!
        end
      end
    end

    workout_session_dup
  end
end
