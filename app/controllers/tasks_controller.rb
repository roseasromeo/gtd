class TasksController < ApplicationController
  before_action :set_task, except: [:new, :create, :search]
  before_action :set_user
  before_action :set_default_project
  before_action :set_project
  before_action :set_default_location
  before_action :set_location, except: [:search]
  before_action :time_collection, only: [:new, :edit, :create, :update, :search]
  before_action :energy_collection, only: [:new, :edit, :create, :update, :search]

  # GET /tasks
  # GET /tasks.json
  #def index
    #if logged_in?
      #@inboxes = Inbox.where(user: @user)
    #else
      #redirect_to login_path
    #end
  #end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    if logged_in?
      @tags = @task.tags
    else
      redirect_to login_path
    end
  end

  # GET /tasks/new
  def new
    if logged_in?
      @task = Task.new
      @projects = Project.where(user: @user)
      @locations = Location.where(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /tasks/1/edit
  def edit
    if !(logged_in? && @task.project.user == current_user)
      redirect_to login_path
    else
      @projects = Project.where(user: @user)
      @locations = Location.where(user: @user)
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    if logged_in?
      @project = Project.find(task_params[:project_id])
      @projects = Project.where(user: @user)
      @locations = Location.where(user: @user)
      if @project == nil
        @project = @default_project
      end
      @location = Location.find(task_params[:location_id])
      if @location == nil
        @location = @default_location
      end
      @task = Task.new(name: task_params[:name], description: task_params[:description], project: @project, location: @location, time: Task.time_name(task_params[:time].to_i), energy: task_params[:energy])
      if @task.save
        redirect_to [@project,@task]
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if logged_in?
      if params[:commit] == "Save Tags"
        @projects = Project.where(user: @user)
        @locations = Location.where(user: @user)
        if @task.update(task_params)
          redirect_to [@project,@task]
        else
          render 'edit_tags'
        end
      else
        @projects = Project.where(user: @user)
        @locations = Location.where(user: @user)
        if @task.update(name: task_params[:name], description: task_params[:description], project: @project, location: @location, time: Task.time_name(task_params[:time].to_i), energy: task_params[:energy])
          redirect_to [@project,@task]
        else
          render 'edit'
        end
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    if logged_in? && @task.user == current_user
      @task.destroy
      redirect_to projects_path
    else
      redirect_to projects_path
    end
  end

  def complete
    if logged_in? && @task.project.user == current_user
      @task.complete
      redirect_to project_path(@project)
    else
      redirect_to projects_path
    end
  end

  def uncomplete
    if logged_in? && @task.project.user == current_user
      @task.uncomplete
      redirect_to [@project,@task]
    else
      redirect_to projects_path
    end
  end

  def edit_tags
    @tags = Tag.where(user: @user)
  end

  def search
    if params[:commit] == "Filter"
      # Perform search
      all_tasks = Task.joins(:project).where(projects: {user: @user})

      # Location
      @location = Location.find(params[:location_id])
      loc_tasks = all_tasks.where(location: @location)
      # Include Anywhere?
      if params[:anywhere] != nil && params[:anywhere] == "1"
        any_tasks = all_tasks.where(location: @default_location)
        loc_tasks = loc_tasks.or(any_tasks).distinct
      end

      # Time (includes all tasks of lower time with sorting to put highest time first)
      time_tasks = Task.none
      @time_collection.each do |k,v|
        if v <= params[:time].to_i
          time_tasks = time_tasks.or(loc_tasks.where(time: v))
        end
      end
      time_tasks = time_tasks.order(time: :desc)

      # Energy (includes all tasks of lower energy with sorting to put highest energy first)
      energy_tasks = Task.none
      @energy_collection.each do |k,v|
        if v <= params[:energy].to_i
          energy_tasks = energy_tasks.or(time_tasks.where(energy: k))
        end
      end
      energy_tasks = energy_tasks.order(time: :desc, energy: :desc)


      @tasks = energy_tasks
      render 'results'
      #available_users = User.includes(:final_characters).where(:final_characters => {:user_id => nil}).or(User.includes(:final_characters).merge(FinalCharacter.where.not(character_system: @character_system)))
      #@possible_users = available_users.or(User.where(id: @character_user.id).includes(:final_characters)).distinct
    else
      # Render search
      @locations = Location.where(user: @user)
      @tags = Tag.where(user: @user)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      if params.has_key?(:project_id)
        @project = Project.find(params[:project_id])
        if @project.user != current_user
          @project = @default_project
        end
      elsif params[:task] != nil && params[:task].has_key?(:project_id)
        @project = Project.find(params[:task][:project_id])
        if @project.user != current_user
          @project = @default_project
        end
      else
        if @task == nil
          @project = @default_project
        else
          @project = @task.project
        end
        if @project == nil
          @project = @default_project
        end
      end
    end

    def set_default_project
      @default_project = Project.where(user: @user, name: "Unassigned").first
    end

    def set_user
      @user = current_user
    end

    def set_location
      if params.has_key?(:location_id)
        @location = Location.find(params[:location_id])
        if @location.user != current_user
          @location = @default_location
        end
      elsif params[:task] != nil && params[:task].has_key?(:location_id)
        @location = Location.find(params[:task][:location_id])
        if @location.user != current_user
          @location = @default_location
        end
      else
        if @task == nil
          @location = @default_location
        else
          @location = @task.location
        end
        if @location == nil
          @location = @default_location
        end
      end
    end

    def set_default_location
      @default_location = Location.where(user: @user, name: "Anywhere").first
    end

    def time_collection
      @time_collection = Hash.new
      Task.time_names.each do |k,v|
        @time_collection[k] = v
      end
    end
    def energy_collection
      @energy_collection = { low: 1, medium: 2, high: 3 }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:project_id, :location_id, :name, :description, :time, :energy, tag_ids: [])
    end

    def tag_params
      tag_params = params[:task][:tag_ids]
      tag_params.shift
      tag_params
    end

    def update_tags
      success = true
      tag_params.each do |tag_sid|

      end
    end
end
