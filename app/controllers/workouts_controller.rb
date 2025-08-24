class WorkoutsController < ApplicationController
  def index
    @workouts = Current.user.workouts
  end

  def new
    @workout = Workout.new
  end

  def create
    @workout = Workout.new(workout_params)
    @workout.author = Current.user

    if @workout.save
      redirect_to workouts_path, notice: "Workout successfuly created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new_from_templates 
    workouts = Current.user.workouts.map { |workout| workout.name }
    @templates = WorkoutTemplates::WORKOUTS.select { |template| !workouts.include? template[:name] }
  end
  end

  private

  def workout_params
    params.expect workout: [ :name, :description, :workout_type ]
  end
end
