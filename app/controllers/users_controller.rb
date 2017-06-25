class UsersController < ApplicationController
  before_action :admin_or_user_account, only: :edit
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      WelcomeMailer.welcome_email(@user).deliver
      flash[:notice] = "You've created a new account. Check your email inbox for instructions!"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There were errors with your submission"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    byebug
    if @user.update(user_params)
      flash[:notice] = "You've successfully updated your user profile information."
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There were errors with your submission"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :phone_number, :password_confirmation)
  end

  def admin_or_user_account
    unless  logged_in? && params[:id].to_i == current_user.id
      flash[:error] = "You can only edit your own profile"
      redirect_to root_path
    end
  end
end
