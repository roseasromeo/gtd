class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all
  # end

  # GET /users/1
  # GET /users/1.json
  def show
    if @user == current_user

    else
      redirect_to root_path
    end
  end

  # GET /users/new
  def new
    @user = User.new(:password => "")
  end

  # GET /users/1/edit
  def edit
    if @user == current_user

    else
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      #session[:user_id] = @user.id
      @errors = @user.errors
      redirect_to :login
    else
      @errors = @user.errors
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user == current_user && @user = User.update(user_params)
      redirect_to root_path
    else
      @errors = @user.errors
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user == current_user
      @user.destroy
      session[:user_id] = nil
      redirect_to '/'
    else
      redirect_to login_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password)
    end
end
