require 'rails_helper'

describe PasswordResetsController do
  context "valid user account" do
    it "stores a random string for a user to reset password" do
      user = create(:user)
      post :create, params: {email: user.email}
      expect(user.reload.reset_token).not_to be_nil
    end
  end
  context "invalid user account"
end
