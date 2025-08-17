class WorkoutSessionsController < ApplicationController
  def index
    @workout_sessions = Current.user.workout_sessions
  end

  def new
    @workout_session = WorkoutSession.new
  end

  def show
    @workout_session = WorkoutSession.find(params[:id])
  end

  def create
    @workout_session = WorkoutSession.new
    @workout_session.user = Current.user

    if @workout_session.save
      redirect_to @workout_session, notice: "Session successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
end
