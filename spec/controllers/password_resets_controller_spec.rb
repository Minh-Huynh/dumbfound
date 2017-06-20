require 'rails_helper'

describe PasswordResetsController do
  describe "passwordresets#create" do 
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
      it "redirects user to sent email confirmation page" do
        user = create(:user)
        post :create, params: {email: user.email}
        expect(response).to redirect_to new_session_path
      end
    end
    context "invalid user account" do
      it "re-renders the page" do
        user = build(:user)
        post :create, params: {email: user.email}
        expect(response).to  render_template :new
      end
      it "populates flash error message" do
        user = build(:user)
        post :create, params: {email: user.email}
        expect(flash[:error]).not_to be_nil
      end
      it "doesn't send the reset email" do
        user = build(:user)
        post :create, params: {email: user.email}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end 
  end
  describe "passwordresets#edit" do
    context "valid token" do
      it "renders template" do
        user = create(:user)
        user.reset_token = SecureRandom.urlsafe_base64
        user.save
        get :edit, params: {token: user.reset_token}
        expect(response).to render_template :edit
      end
    end
    context "invalid token" do
      it "redirects to root" do
        user = create(:user)
        old_token = SecureRandom.urlsafe_base64
        user.reset_token = old_token 
        user.reset_token = SecureRandom.urlsafe_base64
        user.save
        get :edit, params: {token: old_token}
        expect(response).to redirect_to :root
      end
      it "populates flash with error message" do
        user = create(:user)
        old_token = SecureRandom.urlsafe_base64
        user.reset_token = old_token 
        user.reset_token = SecureRandom.urlsafe_base64
        user.save
        get :edit, params: {token: old_token}
        expect(flash[:error]).not_to be_nil
      end
    end
  end
end
