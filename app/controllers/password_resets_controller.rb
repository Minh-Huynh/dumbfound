class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    url_string = SecureRandom.urlsafe_base64
    user.reset_token = url_string
    user.save
  end
end
