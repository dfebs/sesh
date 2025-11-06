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
    if index == 0
      return nil
    end

    if index == 1
      return send_to_order_top
    end

    previous_item = workout_instances[index - 1]
    previous_item_further = workout_instances[index - 2]

    self.order_index = (previous_item.order_index + previous_item_further.order_index) / 2
    previous_item
  end

  def shift_order_down
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self

    if index == workout_instances.length - 1
      return nil
    end

    if index == workout_instances.length - 2
      return send_to_order_bottom
    end

    next_item = workout_instances[index + 1]
    following_item = workout_instances[index + 2]

    self.order_index = (next_item.order_index + following_item.order_index) / 2.0
    next_item
  end

  def send_to_order_top
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self
    if index == 0
      return nil
    end

    to_swap_with = workout_session.workout_instances.order(:order_index).first
    self.order_index = (to_swap_with.order_index / 2)

    to_swap_with
  end

  def send_to_order_bottom
    workout_instances = workout_session.workout_instances.order(:order_index)
    index = workout_instances.index self

    if index == workout_instances.length - 1
      return nil
    end

    to_swap_with = workout_session.workout_instances.order(:order_index).last
    self.order_index = (to_swap_with.order_index + 1.0).floor

    to_swap_with
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
