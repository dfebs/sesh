class WorkoutInstance < ApplicationRecord
  belongs_to :workout_session
  belongs_to :workout

  has_many :workout_sets, dependent: :destroy

  def volume
    workout_sets.sum { |set| set.amount * set.reps }
  end
end
