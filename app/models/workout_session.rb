class WorkoutSession < ApplicationRecord
  belongs_to :user
  has_many :workout_instances, dependent: :destroy
end
