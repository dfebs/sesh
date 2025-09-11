class WorkoutSession < ApplicationRecord
  belongs_to :user
  has_many :workout_instances, dependent: :destroy

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
end
