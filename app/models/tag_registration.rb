class TagRegistration < ApplicationRecord
  belongs_to :tag
  belongs_to :workout
  validates :tag, presence: true
  validates :workout, presence: true
end
