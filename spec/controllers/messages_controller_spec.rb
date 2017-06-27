require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  describe "Messages#reply" do
    context "valid registered user" do
      it "makes a google directions API request"
      it "sends a text message to user phone number via Twilio"
    end
    context "unregistered user" do
      it "doesn't make a google directions API request"
      it "doesn't send a text message"
    end
    context "valid direction request" do
      it "makes a google directions API request"
      it "sends a text message to user phone number via Twilio"
    end
    context "invalid directions request" do
      it "sends the user text notification of invalid request"
    end
  end
end
  
