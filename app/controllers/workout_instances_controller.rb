class WorkoutInstancesController < ApplicationController
  rate_limit to: 100, within: 1.minute
  before_action :get_workout_session, only: %i[ new create ]
  before_action :authorize_user, only: %i[create]

  def new
    @workout_instance = WorkoutInstance.new
  end

  def create
    @workout_instance = @workout_session.workout_instances.new(workout_instance_params)

    begin
      ActiveRecord::Base.transaction do
        @workout_instance.save!
        best_workout_instance = WorkoutInstance.highest_volume(Current.user, @workout_instance)
        workout_sets = WorkoutInstance.dup_workout_sets(best_workout_instance, @workout_instance)
        workout_sets.each(&:save!)

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @workout_session, notice: "Workout instance created" }
        end
      rescue ActiveRecord::RecordInvalid
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @workout_instance = WorkoutInstance.find(params[:id])
    @workout_instance.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Successfully deleted workout instance" }
    end
  end

  private
  def get_workout_session
    @workout_session = WorkoutSession.find(params[:workout_session_id])
  end

  def workout_instance_params
    params.expect workout_instance: [ :workout_id ]
  end

  def authorize_user
    if Current.user != @workout_session.user
      redirect_to workout_sessions_path, alert: "You do not have permission to perform this action"
    end
  end

  def save_workout_session_with_sets
  end
end
