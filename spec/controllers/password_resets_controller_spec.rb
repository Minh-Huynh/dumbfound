require 'rails_helper'

describe PasswordResetsController do
  context "valid user account" do
    it "stores a random string for a user to reset password" do
      user = create(:user)
      post :create, params: {email: user.email}
      expect(user.reload.reset_token).not_to be_nil
    end
    it "sends an email" do
      user = create(:user)
      post :create, params: {email: user.email}
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    it "sends an email to the correct recipient" do
      user = create(:user)
      post :create, params: {email: user.email}
      expect(ActionMailer::Base.deliveries.first.to.first).to eq(user.email)
    end
    it "redirects user to sent email confirmation page"
  end
  context "invalid user account"
end
