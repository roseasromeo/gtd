class RefItemsController < ApplicationController
  before_action :set_ref_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_default_folder
  before_action :set_folder

  # GET /ref_items
  # GET /ref_items.json
  # def index
  #   @ref_items = RefItem.all
  # end

  # GET /ref_items/1
  # GET /ref_items/1.json
  def show
    if logged_in?
    else
      redirect_to login_path
    end
  end

  # GET /ref_items/new
  def new
    if logged_in?
      @ref_item = RefItem.new
      @folders = Folder.where(user: @user).order(deletable: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /ref_items/1/edit
  def edit
    if !(logged_in? && @ref_item.folder.user == current_user)
      redirect_to login_path
    else
      @folders = Folder.where(user: @user).order(deletable: :asc, name: :asc)
    end
  end

  # POST /ref_items
  # POST /ref_items.json
  def create
    if logged_in?
      @ref_item = RefItem.new(ref_item_params)

      if @ref_item.save
        redirect_to folder_ref_item_path(@folder,@ref_item)
      else
        @folders = Folder.where(user: @user).order(deletable: :asc, name: :asc)
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /ref_items/1
  # PATCH/PUT /ref_items/1.json
  def update
    if logged_in?
      if @ref_item.update(ref_item_params)
        redirect_to folder_ref_item_path(@folder,@ref_item)
      else
        @folders = Folder.where(user: @user).order(deletable: :asc, name: :asc)
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /ref_items/1
  # DELETE /ref_items/1.json
  def destroy
    if logged_in? && @ref_item.folder.user == current_user
      @ref_item.destroy
      redirect_to folders_path
    else
      redirect_to folders_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ref_item
      @ref_item = RefItem.find(params[:id])
    end

    def set_folder
      if params.has_key?(:folder_id)
        @folder = Folder.find(params[:folder_id])
        if @folder.user != current_user
          @folder = @default
        end
      else
        @folder = @ref_item.folder
        if @folder == nil
          @folder = @default
        end
      end
    end

    def set_user
      @user = current_user
    end

    def set_default_folder
      @default = Folder.where(user: @user, name: "General Reference").first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ref_item_params
      params.require(:ref_item).permit(:name, :description, :folder_id)
    end
end
