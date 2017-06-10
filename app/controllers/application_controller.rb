class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user

  def current_user
    User.find(session[:current_user_id])
  end

  def login_user(user_id)
    session[:current_user_id] = user_id
  end

  def logout_user
    session[:current_user_id] = nil
  end

  def logged_in?
    true unless session[:current_user_id].nil?
  end
end
