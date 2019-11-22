class PrintChecklistsController < ApplicationController
  before_action :mode
  before_action :set_print_checklist, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /print_checklists
  # GET /print_checklists.json
  def index
    if logged_in?
      @print_checklists = PrintChecklist.where(user: @user).order(name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /print_checklists/1
  # GET /print_checklists/1.json
  def show
    if logged_in?
      @print_checklist_items = @print_checklist.print_checklist_items
    else
      redirect_to login_path
    end
  end

  # GET /print_checklists/new
  def new
    if logged_in?
      if params[:item_id] != nil
        item = Item.find(params[:item_id].to_i)
        @print_checklist = PrintChecklist.new(name: item.name, description: item.description)
      else
        @print_checklist = PrintChecklist.new(user: @user)
      end
    else
      redirect_to login_path
    end
  end

  # GET /print_checklists/1/edit
  def edit
    if !(logged_in? && @print_checklist.user == current_user)
      redirect_to login_path
    end
  end

  # POST /print_checklists
  # POST /print_checklists.json
  def create
    if logged_in?
      @print_checklist = PrintChecklist.new(print_checklist_params.merge(user_id: @user.id))

      if @print_checklist.save
        if params[:develop] != nil
          @item = Item.find(params[:print_checklist][:item_id])
          redirect_to develop_inbox_path(@item.inbox, item: @item.id, next_step: "print_checklist", print_checklist_id: @print_checklist)
        else
          redirect_to print_checklist_path(@print_checklist)
        end
      else
        if params[:develop] != nil
          @item = Item.find(params[:print_checklist][:item_id])
          @inbox = @item.inbox
          @step = "make_print_checklist"
          render "develop/develop"
        else
          render 'new'
        end
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /print_checklists/1
  # PATCH/PUT /print_checklists/1.json
  def update
    if logged_in? && @print_checklist.user == current_user
      if @print_checklist.update(print_checklist_params)
        if params[:develop] != nil
          @item = Item.find(params[:print_checklist][:item_id])
          redirect_to develop_inbox_path(@item.inbox, item: @item.id, next_step: "print_checklist", print_checklist_id: @print_checklist)
        else
          redirect_to print_checklist_path(@print_checklist)
        end
      else
        if params[:develop] != nil
          @item = Item.find(params[:print_checklist][:item_id])
          @inbox = @item.inbox
          @step = "add_to_print_checklist"
          render "develop/develop"
        else
          render 'edit'
        end
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /print_checklists/1
  # DELETE /print_checklists/1.json
  def destroy
    if logged_in? && @print_checklist.user == current_user
      @print_checklist.destroy
      redirect_to print_checklists_path
    else
      redirect_to print_checklists_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_print_checklist
      @print_checklist = PrintChecklist.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def print_checklist_params
      params.require(:print_checklist).permit(:name, :description, print_checklist_items_attributes: [:id, :name, :completed, :_destroy])
    end
end
