require_relative "../config/environment"

workout_sessions = WorkoutSession.all
workout_sessions.each do  | workout_session |
  current_index = 1.0
  workout_session.workout_instances.each do | workout_instance |
    workout_instance.order_index = current_index
    workout_instance.save!
    current_index += 1.0
  end
end
