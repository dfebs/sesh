class Workout < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :workout_instances, dependent: :destroy
  has_many :workout_sets, through: :workout_instances
  has_many :tag_registrations, dependent: :destroy
  has_many :tags, through: :tag_registrations

  validates :name, presence: true
  validates_size_of :name, within: 1..50

  validates :description, presence: true
  validates_size_of :description, within: 1..500

  validates :workout_type, presence: true
  validates_size_of :workout_type, within: 1..50

  validates :author, presence: true

  before_validation :check_uniqueness

  def highest_volume
    completed_workout_instances = workout_instances.filter { |workout_instance| workout_instance.workout_session.completed? }
    completed_workout_instances.max_by(&:volume)&.volume || 0
  end

  def unit
    author.user_config.get_unit workout_type
  end

  def check_uniqueness
    downcase = name.downcase
    user_workouts = Workout.where(author: author).where.not(id: self.id)
    user_workouts.each do |workout|
      if workout.name.downcase == downcase
        errors.add :name, "is already used in another workout"
      end
    end
  end
end
