class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :archive, :unarchive]
  before_action :set_user
  before_action :set_default_project, only: [:destroy]

  # GET /projects
  # GET /projects.json
  def index
    if logged_in?
      @projects = Project.where(user: @user).order(archived: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if logged_in?
      #@tasks = @inbox.tasks
    else
      redirect_to login_path
    end
  end

  # GET /projects/new
  def new
    if logged_in?
      @project = Project.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /projects/1/edit
  def edit
    if !(logged_in? && @project.user == current_user)
      redirect_to login_path
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    if logged_in?
      @project = Project.new(name: project_params[:name],description: project_params[:description], user:@user)

      if @project.save
        redirect_to @project
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if logged_in? && @project.user == current_user
      if @project.update(name: project_params[:name], description: project_params[:description], user: @user)
        redirect_to @project
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if logged_in? && @project.user == current_user
      @project.destroy
      redirect_to projects_path
    else
      redirect_to projects_path
    end
  end

  def archive
    if logged_in? && @project.user == current_user
      if @project.deletable?
        @project.archive
      end
      redirect_to projects_path
    else
      redirect_to projects_path
    end
  end

  def unarchive
    if logged_in? && @project.user == current_user
      @project.unarchive
      redirect_to @project
    else
      redirect_to projects_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def set_default_project
      @default = Project.where(user: @user, name: "Unassigned").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
