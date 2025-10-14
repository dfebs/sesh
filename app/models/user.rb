class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy
  has_many :workouts, dependent: :destroy, inverse_of: "author"
  has_one :user_config, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, length: { maximum: 255 }
  after_create_commit -> { create_user_config }

  generates_token_for :email_confirmation, expires_in: 1.day

  private
  def create_user_config
    config = UserConfig.new(
      short_distance_unit: Constants::SHORT_DISTANCE_UNITS[0],
      long_distance_unit: Constants::LONG_DISTANCE_UNITS[0],
      weight_unit: Constants::WEIGHT_UNITS[0],
      user_id: self.id
    )

    config.save!
  end
end
