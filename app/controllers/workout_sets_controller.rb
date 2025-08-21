class WorkoutSetsController < ApplicationController
  before_action :get_workout_instance, only: %i[new create]

  # TODO see if we even need a workout instance here. Might not.
  def new
    @workout_set = @workout_instance.workout_sets.new
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

  private
  def workout_set_params
    params.expect workout_set: [ :reps, :amount ]
  end

  def get_workout_instance
    @workout_instance = WorkoutInstance.find(params[:workout_instance_id])
  end
end
