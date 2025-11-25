class WorkoutsController < ApplicationController
  rate_limit to: 100, within: 1.minute
  before_action :get_workout, only: %i[ show edit update toggle_archived ]
  before_action :authorize_user, only: %i[ show edit update toggle_archived ]

  def index
    @archived = params[:archived].nil? ? false : params[:archived]
    @workouts = Current.user.workouts.where(archived: @archived).order("lower(name)")
    workout_names = @workouts.map { |workout| workout.name }
    @templates = WorkoutTemplates::WORKOUTS.each_with_index.select { |template, _| !workout_names.include? template[:name] }
  end

  def new
    @workout = Workout.new
  end

  def show
    @workout_instances = @workout.workout_instances.select { |instance| instance.workout_session.completed? }
    @workout_instances = @workout_instances.sort_by do | instance |
      instance.workout_session.date_completed
    end

    @workout_instances_desc = @workout_instances.reverse

    @labels = @workout_instances.map { | instance | instance.workout_session.date_completed }
    @data = @workout_instances.map { | instance | instance.volume }
    @highest_attempts = @workout_instances.map { | instance | instance.highest_attempt }
  end

  def edit
  end

  def toggle_archived
    @workout.archived = !@workout.archived
    @workout.save!
    # TODO change this
    redirect_to root_path, notice: "Successfully toggled archive status"
  end

  def update
    if params[:tag_ids].nil?
      flash.now[:alert] = "Must select tags (checkboxes) when editing a workout"
      render :new, status: :unprocessable_entity
      return
    end

    begin
      ActiveRecord::Base.transaction do
        @workout.update(workout_params)
        @workout.save!
        merge_tags_by_id(@workout, params[:tag_ids])
      end

      # TODO: might be worth making this go to the show path (i.e. workout_path(@workout))
      redirect_to workouts_path, notice: "Exercise successfully edited"
    rescue
      flash.now[:alert] = @workout.errors.full_messages.join("")
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @workout = Workout.new(workout_params)

    if params[:tag_ids].nil?
      flash.now[:alert] = "Must select tags (checkboxes) when creating a workout"
      render :new, status: :unprocessable_entity
      return
    end

    @workout.author = Current.user

    begin
      ActiveRecord::Base.transaction do
        @workout.save!
        add_tags_by_id(@workout, params[:tag_ids])
      end

      redirect_to workouts_path, notice: "Exercise successfully created"
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = @workout.errors.full_messages.join("")
      render :new, status: :unprocessable_entity
    end
  end

  def new_from_templates
    workouts = Current.user.workouts.map { |workout| workout.name }
    @templates = WorkoutTemplates::WORKOUTS.each_with_index.select { |template, _| !workouts.include? template[:name] }
    if !@templates.any?
      redirect_to workouts_path, alert: "There are no more templates for you to add to your workouts."
    end
  end

  def create_from_templates
    template_indices = params[:template_indices]
    if template_indices.nil?
      flash.now[:alert] = "Please select a template to add."
      render_flash_stream(:unprocessable_entity)
      return
    end
    template_indices = template_indices.map &:to_i

    begin
      ActiveRecord::Base.transaction do
        create_workouts_with_tags_from_templates template_indices
        redirect_to workouts_path, notice: "Successfully created workouts from templates."
      end
    rescue ActiveRecord::RecordInvalid
      render new_from_templates, alert: "Could not create workouts from template."
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

  def authorize_user
    if @workout.author != Current.user
      redirect_to workout_sessions_path, alert: "You do not have permission to perform this action"
    end
  end

  def get_workout
    @workout = Workout.find(params[:id])
  end

  def check_for_tag_ids
  end
end
