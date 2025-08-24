class TagRegistration < ApplicationRecord
  belongs_to :tag
  belongs_to :workout
end
