class WorkoutsController < ApplicationController
  def index
    @workouts = Current.user.workouts
  end

  def new
    @workout = Workout.new
  end

  def show
    # This will most likely be where the chart goes
    # @workout = Workout.find(params[:workout_id])
  end

  def edit
    @workout = Workout.find(params[:id])
  end

  def update
    @workout = Workout.find(params[:id])

    begin
      ActiveRecord::Base.transaction do
        @workout.save!
        merge_tags_by_id(@workout, params[:tag_ids])
      end

      # TODO: might be worth making this go to the show path (i.e. workout_path(@workout))
      redirect_to workouts_path, notice: "Workout successfully edited"
    rescue
      render :edit, status: :unprocessable_entity
    end
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

  def merge_tags_by_id (workout, tag_ids)
    tag_registrations = workout.tag_registrations.includes(:tag, :workout)
    do_not_add = []

    workout.tags.all.each do |tag|
      tag_id_str = tag.id.to_s

      if !tag_ids.include? tag_id_str
        tag_registrations.find_by(tag_id: tag.id, workout_id: workout.id).destroy!
      else
        do_not_add.push(tag_id_str)
      end
    end

    tags_to_include = Tag.find(tag_ids).select { |tag| !do_not_add.include? tag.id.to_s }
    tags_to_include.each do |tag|
      add_tag_registration workout, tag
    end
  end

  def add_tags_by_id(workout, tag_ids)
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
