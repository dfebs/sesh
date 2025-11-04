class WorkoutInstance < ApplicationRecord
  belongs_to :workout_session
  belongs_to :workout

  after_validation :send_to_order_bottom, on: :create
  has_many :workout_sets, dependent: :destroy
  validate :check_max_instances, on: :create

  def volume
    workout_sets.sum { |set| set.amount * set.reps }
  end

  def highest_attempt
    workout_sets.max_by(&:amount).amount
  end

  def name
    workout.name
  end

  def user
    workout_session.user
  end

  def check_max_instances
    max = 20
    if workout_session.workout_instances.length > max
      errors.add :base, "Max number of workout sessions reached. Max is #{max}."
    end
  end

  def shift_order_up
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self
    if index == 1
      send_to_order_top
      return
    end

    if index != 0
      self.order_index = (workout_instances[index - 1].order_index + workout_instances[index - 2].order_index) / 2
    end
  end

  def shift_order_down
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self
    if index == workout_instances.length - 2
      send_to_order_bottom
      return
    end

    if !(index == workout_instances.length - 1)
      next_item_order_index = workout_instances[index + 1].order_index
      following_item_order_index = workout_instances[index + 2].order_index
      self.order_index = (next_item_order_index + following_item_order_index) / 2.0
    end
  end

  def send_to_order_top
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self
    if index != 0
      first_index = workout_session.workout_instances.order(:order_index).first.order_index
      self.order_index = (first_index / 2)
    end
  end

  def send_to_order_bottom
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self # TODO: this may or may not work

    if index != workout_instances.length - 1
      last_index = workout_session.workout_instances.order(:order_index).last.order_index
      self.order_index = (last_index + 1.0).floor
    end
  end

  def self.dup_workout_sets(origin, receiver)
    sets = origin.workout_sets.map(&:dup)
    sets.each do |set|
      set.workout_instance = receiver
    end
    sets
  end

  def self.highest_volume (user, workout_instance)
    user_workout_instances = WorkoutInstance.where(workout: workout_instance.workout).select { |instance| instance.user == user }
    user_workout_instances.max { |a, b| a.volume <=> b.volume }
  end
end
