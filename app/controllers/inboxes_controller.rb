class InboxesController < ApplicationController
  before_action :set_inbox, only: [:show, :edit, :update, :destroy, :develop]
  before_action :set_user
  before_action :set_default_inbox, only: [:destroy]

  # GET /inboxes
  # GET /inboxes.json
  def index
    if logged_in?
      @inboxes = Inbox.where(user: @user).order(deletable: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /inboxes/1
  # GET /inboxes/1.json
  def show
    if logged_in?
      @items = @inbox.items.order(name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /inboxes/new
  def new
    if logged_in?
      @inbox = Inbox.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /inboxes/1/edit
  def edit
    if !(logged_in? && @inbox.user == current_user)
      redirect_to login_path
    end
  end

  # POST /inboxes
  # POST /inboxes.json
  def create
    if logged_in?
      @inbox = Inbox.new(name: inbox_params[:name], user:@user)

      if @inbox.save
        redirect_to @inbox
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /inboxes/1
  # PATCH/PUT /inboxes/1.json
  def update
    if logged_in?
      if @inbox.update(name: inbox_params[:name], user:@user)
        redirect_to @inbox
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /inboxes/1
  # DELETE /inboxes/1.json
  def destroy
    if logged_in? && @inbox.user == current_user
      @inbox.items.each do |item|
        item.update(inbox: @default)
      end
      @inbox.reload
      @inbox.destroy
      redirect_to inboxes_path
    else
      redirect_to inboxes_path
    end
  end

  def develop
    if @inbox.items.empty?
      redirect_to @inbox
    end
    @step = set_step
    @item = set_item
    if @step == "delete"
      next_item_tmp = next_item(@item.id)
      @item.destroy
      @item = next_item_tmp
      @step = "action"
    elsif @step == "next"
      @item = next_item(@item.id)
      @step = "action"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inbox
      @inbox = Inbox.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def set_default_inbox
      @default = Inbox.where(user: @user, name: "Default").first
    end

    def set_item
      if params[:item] != nil
        item = Item.find(params[:item])
      end
      if params[:item] == nil || item.inbox != @inbox
        item = @inbox.items.order(created_at: :desc).first
      end
      item
    end

    def set_step
      step = "action"
      if params[:next_step] != nil
        step = params[:next_step]
      end
      step
    end

    def next_item(id)
      @inbox.items.where("id > ?", id).order(id: :asc).first ||   @inbox.items.first
    end

    def prev_item(id)
      @inbox.items.where("id < ?", id).order(id: :desc).first ||   @inbox.items.last
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inbox_params
      params.require(:inbox).permit(:name)
    end
end
