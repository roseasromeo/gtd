class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_location, only: [:destroy]
  before_action :set_default_project, only: [:show]

  # GET /locations
  # GET /locations.json
  def index
    if logged_in?
      @locations = Location.where(user: @user).order(deletable: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    if logged_in?
      @tasks = @location.tasks
    else
      redirect_to login_path
    end
  end

  # GET /locations/new
  def new
    if logged_in?
      @location = Location.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /locations/1/edit
  def edit
    if !(logged_in? && @location.user == current_user)
      redirect_to login_path
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    if logged_in?
      @location = Location.new(name: location_params[:name], user: @user)

      if @location.save
        redirect_to @location
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    if logged_in? && @location.user == current_user
      if @location.update(name: location_params[:name], user: @user)
        redirect_to @location
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    if logged_in? && @location.user == current_user
      @location.tasks.each do |task|
        task.update(location: @default)
      end
      @location.reload
      @location.destroy
      redirect_to locations_path
    else
      redirect_to locations_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def set_default_location
      @default = Location.where(user: @user, name: "Anywhere").first
    end

    def set_default_project
      @default_project = Project.where(user: @user, name: "Unassigned").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name)
    end
end
