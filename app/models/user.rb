class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy
  has_many :workouts, dependent: :destroy, inverse_of: "author"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
