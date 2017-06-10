require 'rails_helper'

RSpec.describe SessionsController do
  describe "Logging In" do
    context "valid user" do
      it "allows a valid user to log in" do
        valid_user = create(:user, password: "password")
        post :create, params: {email: valid_user.email, password: "password"}
        expect(session[:current_user_id]).to eq(valid_user.id)
      end
      it "redirects valid user to his profile page" do
        valid_user = create(:user, password: "password")
        post :create, params: {email: valid_user.email, password: "password"}
        expect(response).to redirect_to edit_user_path(valid_user)
      end
    end
    context "invalid user" do
      it "doesn't allow a user with wrong password in" do
        valid_user = create(:user, password: "password")
        post :create, params: {email: valid_user.email, password: "wrong_password"}
        expect(session[:current_user_id]).to be_nil
      end
      it "doesn't allow a user with wrong email/username in" do
        valid_user = create(:user, email: "minh@minh.com")
        post :create, params: {email: "wrong@email.com", password: "password"}
        expect(session[:current_user_id]).to be_nil
      end
    end
  end
  describe "Logging Out" do
    it "allows a user to log out" do
      valid_user = create(:user, email: "minh@minh.com")
      delete :destroy, params: {id: valid_user.id}
      expect(session[:current_user_id]).to be_nil
    end
    it "redirects user to root page" do
    end
  end
end
