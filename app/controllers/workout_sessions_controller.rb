class WorkoutSessionsController < ApplicationController
  before_action :get_workout_session, only: %i[show update destroy duplicate]
  before_action :authorize_user, only: %i[show update destroy duplicate]

  def index
    set_workout_sessions
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

    @workout_session = WorkoutSession.new(workout_session_params)
    @workout_session.user = Current.user

    respond_to do |format|
      if @workout_session.save
        format.turbo_stream
        format.html { redirect_to @workout_session, notice: "Session successfully created" }
      else
        flash.now[:alert] = "Failed to create workout session"
        set_workout_sessions
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @workout_session.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Deletion successful" }
    end
  end

  def duplicate
    begin
      ActiveRecord::Base.transaction do
        @workout_session = @workout_session.deep_duplicate
      end
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to workout_sessions_path, notice: "Duplication Successful" }
      end
    rescue ActiveRecord::RecordInvalid
      respond_to do |format|
        set_workout_sessions
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private
  def get_workout_session
    @workout_session = WorkoutSession.find(params[:id])
  end

  def workout_session_params
    params.expect workout_session: [ :title, :date_completed ]
  end

  def set_workout_sessions
    @workout_sessions = Current.user.workout_sessions
    @upcoming_workout_sessions = @workout_sessions.where(date_completed: nil).order(created_at: :desc, updated_at: :desc)
    @completed_workout_sessions = @workout_sessions.where.not(date_completed: nil).order(date_completed: :desc, updated_at: :desc)
  end

  def authorize_user
    if @workout_session.user != Current.user
      redirect_to workout_sessions_path, alert: "You do not have permission to perform this action"
    end
  end
end
