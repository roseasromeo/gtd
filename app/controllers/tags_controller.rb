class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /tags
  # GET /tags.json
  def index
    if logged_in?
      @tags = Tag.where(user: @user).order(name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    if logged_in?
      @tasks = @tag.tasks.order(completed: :asc, name: :asc)
    else
      redirect_to login_path
    end
  end

  # GET /tags/new
  def new
    if logged_in?
      @tag = Tag.new(user: @user)
    else
      redirect_to login_path
    end
  end

  # GET /tags/1/edit
  def edit
    if !(logged_in? && @tag.user == current_user)
      redirect_to login_path
    end
  end

  # POST /tags
  # POST /tags.json
  def create
    if logged_in?
      @tag = Tag.new(name: tag_params[:name], user:@user)

      if @tag.save
        redirect_to @tag
      else
        render 'new'
      end
    else
      redirect_to login_path
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if logged_in? && @tag.user == current_user
      if @tag.update(name: tag_params[:name], user: @user)
        redirect_to @tag
      else
        render 'edit'
      end
    else
      redirect_to login_path
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    if logged_in? && @tag.user == current_user
      @tag.destroy
      redirect_to tags_path
    else
      redirect_to tag_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name)
    end
end
