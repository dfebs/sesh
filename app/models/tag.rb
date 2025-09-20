class Tag < ApplicationRecord
  has_many :tag_registrations, dependent: :destroy
  has_many :workouts, through: :tag_registrations
  validates :title, presence: true
end
