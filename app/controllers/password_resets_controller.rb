class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      flash[:notice] = "An email has been sent with a link to reset your password"
      url_string = SecureRandom.urlsafe_base64
      @user.reset_token = url_string
      @user.save
      PasswordResetMailer.password_reset_email(@user).deliver
      redirect_to new_session_path
    else
      flash[:error] = "There was an error in your submission"
      render :new
    end
  end


end
