class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:notice] = "You've created a new account. Check your email inbox for instructions!"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There were errors with your submission"
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
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
    params.require(:user).permit(:email, :password_digest, :phone_number)
  end
end
