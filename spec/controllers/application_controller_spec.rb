require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
    end
  end
  describe "current_user helper method" do
    it "returns current logged in user" do
      user = create(:user)
      controller.login_user(user.id)
      expect(controller.current_user).to eq(user)
    end
    it "returns nil or false if no user is logged in" do
      expect(controller.current_user).to be_nil
    end
  end
  describe "login_user method" do
    it "logs in a user" do
      user = create(:user)
      controller.login_user(user.id)
      expect(session[:current_user_id]).to eq(user.id)
    end
  end
  describe "logout_user method" do
   it "logs out the user" do
      controller.login_user(create(:user)) 
      controller.logout_user
      expect(session[:current_user_id]).to be_nil
   end
  end 

  describe "logged_in? method" do
    it "returns true if user is logged in" do
      user = create(:user)
      controller.login_user(user.id)
      expect(controller.logged_in?).to be_truthy
    end
    it "return false if user is not logged in" do
      expect(controller.logged_in?).to be_falsy
    end
  end
end
  
