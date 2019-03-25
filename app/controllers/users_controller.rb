class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :correct_user,   only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @user = User.find params[:id]
    @unfollow = current_user.active_relationships.find_by followed: @user
    @follow = current_user.active_relationships.build
    @activities = @user.feed.paginate page: params[:page]
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      remember @user
      flash[:success] = "Welcome to the E-Learning"
      redirect_to user_url(@user)
    else
      render "new"
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    flash[:success] = "User deleted!"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,:password_confirmation
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end