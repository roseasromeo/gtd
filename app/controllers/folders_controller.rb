class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_folder, only: [:destroy]

  # GET /folders
  # GET /folders.json
  def index
    if logged_in?
      @folders = Folder.where(user: @user).order(deletable: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    if logged_in?
      @ref_items = @folder.ref_items.order(name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /folders/new
  def new
    if logged_in?
      @folder = Folder.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /folders/1/edit
  def edit
    if !(logged_in? && @folder.user == current_user)
      redirect_to login_path
    end
  end

  # POST /folders
  # POST /folders.json
  def create
    if logged_in?
      @folder = Folder.new(name: folder_params[:name], description: folder_params[:description], user:@user)
      if @folder.save
        if params[:develop] != nil
          @item = Item.find(params[:folder][:item_id])
          redirect_to develop_inbox_path(@item.inbox, item: @item.id, next_step: "added_folder", folder_id: @folder)
        else
          redirect_to folder_path(@folder)
        end
      else
        if params[:develop] != nil
          @item = Item.find(params[:folder][:item_id])
          @inbox = @item.inbox
          @step = "add_folder"
          render "develop/develop"
        else
          render 'new'
        end
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    if logged_in?
      if @folder.update(name: folder_params[:name], description: folder_params[:description], user:@user)
        redirect_to @folder
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    if logged_in? && @folder.user == current_user
      @folder.ref_items.each do |item|
        item.update(folder: @default)
      end
      @folder.reload
      @folder.destroy
      redirect_to folders_path
    else
      redirect_to folders_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def set_default_folder
      @default = Folder.where(user: @user, name: "General Reference").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name, :description)
    end
end
