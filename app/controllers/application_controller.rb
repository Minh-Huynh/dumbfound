class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    session[:current_user_id]
  end

  def login_user(user_id)
    session[:current_user_id] = user_id
  end
end
