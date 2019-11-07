class InboxesController < ApplicationController
  before_action :set_inbox, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_inbox, only: [:destroy]

  # GET /inboxes
  # GET /inboxes.json
  def index
    if logged_in?
      @inboxes = Inbox.where(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /inboxes/1
  # GET /inboxes/1.json
  def show
    if logged_in?
      @items = @inbox.items
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def inbox_params
      params.require(:inbox).permit(:name)
    end
end
