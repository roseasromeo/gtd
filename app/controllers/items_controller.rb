class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_inbox
  before_action :set_inbox
  before_action :set_default_project, only: [:show]
  before_action :set_default_location, only: [:show]

  # GET /items
  # GET /items.json
  #def index
    #if logged_in?
      #@inboxes = Inbox.where(user: @user)
    #else
      #redirect_to login_path
    #end
  #end

  # GET /items/1
  # GET /items/1.json
  def show
    if logged_in?
    else
      redirect_to login_path
    end
  end

  # GET /items/new
  def new
    if logged_in?
      @item = Item.new
      @inboxes = Inbox.where(user: @user).order(deletable: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /items/1/edit
  def edit
    if !(logged_in? && @item.inbox.user == current_user)
      redirect_to login_path
    else
      @inboxes = Inbox.where(user: @user).order(deletable: :asc, name: :asc)
    end
  end

  # POST /items
  # POST /items.json
  def create
    if logged_in?
      @item = Item.new(item_params)

      if @item.save
        redirect_to inbox_item_path(@inbox,@item)
      else
        @inboxes = Inbox.where(user: @user).order(deletable: :asc, name: :asc)
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if logged_in?
      if @item.update(item_params)
        redirect_to inbox_item_path(@inbox,@item)
      else
        @inboxes = Inbox.where(user: @user).order(deletable: :asc, name: :asc)
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if logged_in? && @item.inbox.user == current_user
      @item.destroy
      redirect_to inboxes_path
    else
      redirect_to inboxes_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_inbox
      if params.has_key?(:inbox_id)
        @inbox = Inbox.find(params[:inbox_id])
        if @inbox.user != current_user
          @inbox = @default
        end
      else
        @inbox = @item.inbox
        if @inbox == nil
          @inbox = @default
        end
      end
    end

    def set_user
      @user = current_user
    end

    def set_default_inbox
      @default = Inbox.where(user: @user, name: "General").first
    end

    def set_default_project
      @default_project = Project.where(user: @user, name: "Unassigned").first
    end

    def set_default_location
      @default_location = Location.where(user: @user, name: "Anywhere").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :inbox_id)
    end
end
