class SessionsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      login_user(@user.id)
      flash[:notice] = "You've successfully logged in"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There are errors in your submission"
      render :new
    end
  end

  def destroy
    logout_user
    redirect_to root_path
  end
end
