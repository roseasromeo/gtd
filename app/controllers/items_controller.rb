class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_inbox, only: [:new, :edit, :show, :destroy]
  before_action :set_inbox, only: [:new, :edit, :show, :destroy]

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
      @inboxes = Inbox.where(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /items/1/edit
  def edit
    if !(logged_in? && @item.inbox.user == current_user)
      redirect_to login_path
    else
      @inboxes = Inbox.where(user: @user)
    end
  end

  # POST /items
  # POST /items.json
  def create
    if logged_in?
      @item = Item.new(item_params)

      if @item.save
        redirect_to [@inbox,@item]
      else
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
        redirect_to [@inbox,@item]
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if logged_in? && @item.user == current_user
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
      @default = Inbox.where(user: @user, name: "Default").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :content, :inbox_id)
    end
end
