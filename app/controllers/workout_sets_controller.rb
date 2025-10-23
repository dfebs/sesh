class WorkoutSetsController < ApplicationController
  rate_limit to: 100, within: 1.minute
  before_action :get_workout_instance, only: %i[new create]
  before_action :get_workout_set, only: %i[destroy edit update duplicate]
  before_action :authorize_user_modify, only: %i[destroy update edit]
  before_action :authorize_user_create, only: %i[new create]

  def new
    @workout_set = @workout_instance.workout_sets.new
  end

  def destroy
    @workout_session = @workout_set.workout_session
    @workout_set.destroy!

    respond_to do | format |
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Deletion successful" }
    end
  end

  def create
    @workout_set = @workout_instance.workout_sets.new(workout_set_params)
    respond_to do | format |
      if @workout_set.save
        format.turbo_stream
        format.html { redirect_to @workout_instance, notice: "Successfully created reps" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @workout_instance = @workout_set.workout_instance
  end

  def update
    respond_to do | format |
      if @workout_set.update(workout_set_params)
        format.turbo_stream
        # TODO: Check this works by temporarily turning off turbo
        format.html { redirect_to @workout_set.workout_session, notice: "Successfully updated reps" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def duplicate
    @workout_instance = @workout_set.workout_instance
    @workout_set_dup = @workout_set.dup
    respond_to do |format|
      if @workout_set_dup.save
        format.turbo_stream
        # TODO: Check this works by temporarily turning off turbo
        format.html { redirect_to @workout_set.workout_session, notice: "Successfully updated reps" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  def workout_set_params
    params.expect workout_set: [ :reps, :amount_imp, :amount_metric ]
  end

  def get_workout_instance
    @workout_instance = WorkoutInstance.find(params[:workout_instance_id])
  end

  def get_workout_set
    @workout_set = WorkoutSet.find(params[:id])
  end

  def authorize_user_modify
    if @workout_set.workout_instance.workout.author != Current.user
      redirect_to workout_session_path, alert: "You are not authorized to perform this action"
    end
  end

  def authorize_user_create
    if @workout_instance.workout.author != Current.user
      redirect_to workout_session_path, alert: "You are not authorized to perform this action"
    end
  end
end
