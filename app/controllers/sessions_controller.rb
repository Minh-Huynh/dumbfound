class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      login_user(user.id)
      redirect_to edit_user_path(user)
    end
  end

end
