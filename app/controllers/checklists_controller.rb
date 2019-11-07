class ChecklistsController < ApplicationController
  before_action :set_checklist, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /checklists
  # GET /checklists.json
  def index
    if logged_in?
      @checklists = Checklist.where(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /checklists/1
  # GET /checklists/1.json
  def show
    if logged_in?
      #@checklist_items = @checklist.checklist_items
    else
      redirect_to login_path
    end
  end

  # GET /checklists/new
  def new
    if logged_in?
      @checklist = Checklist.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /checklists/1/edit
  def edit
    if !(logged_in? && @checklist.user == current_user)
      redirect_to login_path
    end
  end

  # POST /checklists
  # POST /checklists.json
  def create
    @checklist = Checklist.new(checklist_params)
    if logged_in?
      @checklist = Checklist.new(name: checklist_params[:name], description: checklist_params[:description], user: @user)

      if @checklist.save
        redirect_to @checklist
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /checklists/1
  # PATCH/PUT /checklists/1.json
  def update
    if logged_in? && @checklist.user == current_user
      if @checklist.update(name: checklist_params[:name], description: checklist_params[:description], user: @user)
        redirect_to @checklist
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.json
  def destroy
    if logged_in? && @checklist.user == current_user
      @checklist.destroy
      redirect_to checklists_path
    else
      redirect_to checklists_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checklist
      @checklist = Checklist.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checklist_params
      params.require(:checklist).permit(:name, :description)
    end
end
