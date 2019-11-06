class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :uncomplete]
  before_action :set_user
  before_action :set_default_project, only: [:new, :edit, :create, :update, :show, :destroy, :complete, :uncomplete]
  before_action :set_project, only: [:new, :edit, :create, :update, :show, :destroy, :complete, :uncomplete]
  before_action :set_default_location, only: [:new, :edit, :create, :update, :show, :destroy]
  before_action :set_location, only: [:new, :edit, :create, :update, :show, :destroy]
  before_action :time_collection, only: [:new, :edit]

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
      @projects = Project.where(user: @user)
      @locations = Location.where(user: @user)
      if @task.update(name: task_params[:name], description: task_params[:description], project: @project, location: @location, time: Task.time_name(task_params[:time].to_i), energy: task_params[:energy])
        redirect_to [@project,@task]
      else
        render 'edit'
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
      else
        @project = @task.project
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
        @location = @task.location
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:project_id, :location_id, :name, :description, :time, :energy)
    end
end
