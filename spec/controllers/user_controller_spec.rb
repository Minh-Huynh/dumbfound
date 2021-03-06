require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "Users#create" do
    context "valid user" do
      before do
        @valid_user = attributes_for(:user)
        post :create, params: {user: @valid_user}
      end
      it "creates a new user" do
        expect(User.count).to eq(1)
      end
      it "redirects user to profile page" do
        expect(response).to redirect_to edit_user_path(User.last.id)
      end
      it "sends an email" do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it "sends email to correct recipient" do
        expect(ActionMailer::Base.deliveries.first.to.first).to eq(@valid_user[:email])
      end
    end
    context "invalid user" do
      before do
        invalid_user = build(:user, password: '', password_confirmation: '')
        post :create, params: {user: invalid_user.attributes}
      end
      it "does not create an invalid user" do
        expect(User.count).to eq(0)
      end
      it "re-renders create page" do
        expect(response).to render_template(:new)
      end
      it "populates flash with errors" do
        expect(controller).to set_flash[:error]
      end
    end
  end
  describe "Users#update" do
    context "valid update" do
      it "updates user information" do
        user = create(:user)
        patch :update, params: {id: user.id, user: {email: "fictitious_email@email.com"}}
        expect(user.reload.email).to eq("fictitious_email@email.com")
      end
      it "redirects user to profile page" do
        user = create(:user)
        patch :update, params: {id: user.id, user: {email: "fictitious_email@email.com"}}
        expect(response).to redirect_to edit_user_path(User.last.id)
      end
    end
    context "invalid update" do
      it "does not allow user to make invalid update" do
        user = create(:user)
        patch :update, params: {id: user.id, user: {email: ""}}
        expect(user.reload.email).not_to be("")
      end
      it "re-renders update page" do
        user = create(:user)
        patch :update, params: {id: user.id, user: {email: ""}}
        expect(response).to render_template(:edit)
      end
    end
  end
end
  
