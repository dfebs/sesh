class WorkoutsController < ApplicationController
  def index
    @workouts = Current.user.workouts
  end

  def new
    @workout = Workout.new
  end

  def show
    # @workout = Workout.find(params[:workout_id])
  end

  def create
    @workout = Workout.new(workout_params)
    @workout.author = Current.user

    begin
      ActiveRecord::Base.transaction do
        @workout.save!
        add_tags_by_id(@workout, params[:tag_ids])
      end

      redirect_to workouts_path, notice: "Workout successfully created"
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  def new_from_templates
    workouts = Current.user.workouts.map { |workout| workout.name }
    @templates = WorkoutTemplates::WORKOUTS.each_with_index.select { |template, _| !workouts.include? template[:name] }
  end

  def create_from_templates
    template_indices = params[:template_indices].map &:to_i
    begin
      ActiveRecord::Base.transaction do
        create_workouts_with_tags_from_templates template_indices
        redirect_to workouts_path
      end
    rescue ActiveRecord::RecordInvalid
      render new_from_templates, alert: "Could not create workouts from template"
    end
  end

  private

  def workout_params
    params.expect workout: [ :name, :description, :workout_type ]
  end

  def create_workouts_with_tags_from_templates(indices)
    indices.each do |index|
      template = WorkoutTemplates::WORKOUTS[index]
      workout = Workout.new

      build_workout_from_template workout, template
      add_tags_by_name workout, template[:tags]
    end
  end

  def build_workout_from_template(workout, template)
      workout.name = template[:name]
      workout.description = template[:description]
      workout.workout_type = template[:workout_type]
      workout.author = Current.user
      workout.save!
  end

  def add_tags_by_id (workout, tag_ids)
    tags = Tag.find(tag_ids)
    tags.each do |tag|
      add_tag_registration workout, tag
    end
  end

  def add_tags_by_name(workout, tag_names)
    tags = tag_names.map { |title| Tag.find_by(title: title) }
    tags.each do |tag|
      add_tag_registration workout, tag
    end
  end

  def add_tag_registration(workout, tag)
    tag_registration = TagRegistration.new(workout: workout, tag: tag)
    tag_registration.save!
  end
end
