class WorkoutInstance < ApplicationRecord
  belongs_to :workout_session
  belongs_to :workout

  has_many :workout_sets, dependent: :destroy
end
