class WorkoutInstancesController < ApplicationController
  before_action :get_workout_session, only: [ :new, :create ]

  def new
    @workout_instance = WorkoutInstance.new
  end

  def create
    @workout_instance = @workout_session.workout_instances.new(workout_instance_params)
    respond_to do |format|
      if @workout_instance.save
        format.turbo_stream
        format.html { redirect_to @workout_session, notice: "Workout instance created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  def get_workout_session
    @workout_session = WorkoutSession.find(params[:workout_session_id])
  end

  def workout_instance_params
    params.expect workout_instance: [ :workout_id ]
  end
end
