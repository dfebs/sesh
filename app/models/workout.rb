class Workout < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :workout_instances, dependent: :destroy
end
