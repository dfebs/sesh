class WorkoutInstancesController < ApplicationController
  def new
    @workout_instance = WorkoutInstance.new
  end
end
