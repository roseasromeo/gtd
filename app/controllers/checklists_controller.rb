class ChecklistsController < ApplicationController
  before_action :mode
  before_action :set_checklist, only: [:show, :edit, :update, :destroy, :printable]
  before_action :set_user

  # GET /checklists
  # GET /checklists.json
  def index
    if logged_in?
      @checklists = Checklist.where(user: @user).order(name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /checklists/1
  # GET /checklists/1.json
  def show
    if logged_in?
      @checklist_items = @checklist.checklist_items
    else
      redirect_to login_path
    end
  end

  # GET /checklists/new
  def new
    if logged_in?
      if params[:item_id] != nil
        item = Item.find(params[:item_id].to_i)
        @checklist = Checklist.new(name: item.name, description: item.description)
      else
        @checklist = Checklist.new(user: @user)
      end
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
    if logged_in?
      @checklist = Checklist.new(checklist_params.merge(user_id: @user.id))

      if @checklist.save
        if params[:develop] != nil
          @item = Item.find(params[:checklist][:item_id])
          redirect_to develop_inbox_path(@item.inbox, item: @item.id, next_step: "checklist", checklist_id: @checklist)
        else
          redirect_to checklist_path(@checklist)
        end
      else
        if params[:develop] != nil
          @item = Item.find(params[:checklist][:item_id])
          @inbox = @item.inbox
          @step = "make_checklist"
          render "develop/develop"
        else
          render 'new'
        end
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /checklists/1
  # PATCH/PUT /checklists/1.json
  def update
    if logged_in? && @checklist.user == current_user
      if !(@checklist.deletable)
        cl_params = checklist_params.permit(checklist_items_attributes: [:id, :name, :_destroy])
      else
        cl_params = checklist_params
      end
      if @checklist.update(cl_params)
        if params[:develop] != nil
          @item = Item.find(params[:checklist][:item_id])
          redirect_to develop_inbox_path(@item.inbox, item: @item.id, next_step: "checklist", checklist_id: @checklist)
        else
          redirect_to checklist_path(@checklist)
        end
      else
        if params[:develop] != nil
          @item = Item.find(params[:checklist][:item_id])
          @inbox = @item.inbox
          @step = "add_to_checklist"
          render "develop/develop"
        else
          render 'edit'
        end
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.json
  def destroy
    if logged_in? && @checklist.user == current_user && @checklist.deletable?
      @checklist.destroy
      redirect_to checklists_path
    else
      redirect_to checklists_path
    end
  end

  def printable
    if @checklist.user == @user
      @print_checklist = PrintChecklist.new(user: @checklist.user, name: @checklist.name, description: @checklist.description)
      @checklist.checklist_items.each do |item|
        @print_checklist.print_checklist_items.build(name: item.name)
      end
      if @print_checklist.save
        redirect_to @print_checklist
      else
        redirect_to @checklist
      end
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
      params.require(:checklist).permit(:name, :description, checklist_items_attributes: [:id, :name, :_destroy])
    end
end
