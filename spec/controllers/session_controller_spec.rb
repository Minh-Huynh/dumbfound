require 'rails_helper'

RSpec.describe SessionsController do
  context "valid user" do
    it "allows a valid user to log in" do
      valid_user = create(:user, password: "password")
      post :create, params: {email: valid_user.email, password: "password"}
      expect(session[:current_user_id]).to eq(valid_user.id)
    end
    it "redirects valid user to his profile page"
  end
  context "invalid user" do
    it "doesn't allow a user with wrong password in"
    it "doesn't allow a user with wrong email/username in"
  end
end
