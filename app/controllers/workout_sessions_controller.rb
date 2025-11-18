class WorkoutSessionsController < ApplicationController
  rate_limit to: 100, within: 1.minute
  before_action :get_workout_session, only: %i[show update destroy duplicate edit]
  before_action :authorize_user, only: %i[show update destroy duplicate]

  def index
    get_workout_sessions
  end

  def new
    @workout_session = WorkoutSession.new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @workout_session.update(workout_session_params)
        format.turbo_stream
        format.html { redirect_to workout_sessions_path, notice: "Session updated!" }
      else
        flash.now[:alert] = "Failed to update workout session"
        format.html { render :show, status: :unprocessable_entity }
      end
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
        flash.now[:alert] = @workout_session.errors.full_messages.join(", ")
        format.turbo_stream { render_flash_stream(:unprocessable_entity) }
        format.html do
          get_workout_sessions
          render :index, status: :unprocessable_entity
        end
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
        format.html do
          get_workout_sessions
          render :index, notice: "Duplication Successful"
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.join(", ")
      respond_to do |format|
        format.turbo_stream { render_flash_stream(:unprocessable_entity) }
        format.html do
          get_workout_sessions
          render :index, status: :unprocessable_entity
        end
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

  def get_workout_sessions
    today = Date.current
    @workout_sessions = Current.user.workout_sessions
    @upcoming_workout_sessions = @workout_sessions.where(date_completed: nil).order(created_at: :desc, updated_at: :desc)
    @completed_workout_sessions = @workout_sessions.where.not(date_completed: nil).order(date_completed: :desc, updated_at: :desc)
    @completed_sessions_this_week = @completed_workout_sessions.where(date_completed: today.beginning_of_week..today.end_of_week)
    @completed_sessions_last_week = @completed_workout_sessions.where(date_completed: today.beginning_of_week-7.days..today.end_of_week-7.days)
    @completed_sessions_long_ago = @completed_workout_sessions.where(date_completed: ..today.beginning_of_week-8.days)
  end

  def authorize_user
    if @workout_session.user != Current.user
      redirect_to workout_sessions_path, alert: "You do not have permission to perform this action"
    end
  end
end
