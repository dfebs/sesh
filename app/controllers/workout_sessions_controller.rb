class WorkoutSessionsController < ApplicationController
  before_action :initialize_workout_session, only: %i[show update]
  def index
    @workout_sessions = Current.user.workout_sessions
  end

  def new
    @workout_session = WorkoutSession.new
  end

  def show
  end

  def update
    if @workout_session.ready_for_completion? && @workout_session.update(workout_session_params)
      redirect_to workout_sessions_path, notice: "Session updated!"
    else
      flash.now[:alert] = "Failed to update workout session"
      render :show, status: :unprocessable_entity
    end
  end

  def create
    if !Current.user.workouts.any?
      redirect_to new_from_templates_workouts_path, alert: "You must have at least 1 workout to be able to make workout sessions."
      return
    end

    @workout_session = WorkoutSession.new
    @workout_session.user = Current.user

    if @workout_session.save
      redirect_to @workout_session, notice: "Session successfully created"
    else
      flash.now[:alert] = "Failed to create workout session"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def initialize_workout_session
    @workout_session = WorkoutSession.find(params[:id])
  end

  def workout_session_params
    params.expect workout_session: [ :date_completed ]
  end
end
