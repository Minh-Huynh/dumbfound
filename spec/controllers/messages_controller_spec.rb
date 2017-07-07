require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  describe "Messages#reply" do
    context "valid registered user and valid request" do
      let(:user) {create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "From San Gabriel to Pasadena"}}
      before do
        response = double("direction_response")
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:valid_request?).and_return(true)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
        allow_any_instance_of(Message).to receive(:send_message).and_return(true)
      end
      it "makes a google directions API request" do
        expect_any_instance_of(Direction).to receive(:make_request)
        post :reply, params: params
      end
      it "sends a text message to user phone number via Twilio" do
        expect_any_instance_of(Message).to receive(:send_message)
        post :reply, params: params
      end
      it "doesn't allow a user to make more than a set number of requests a month" do
        requests_per_month = 20
        user.update(requests_this_month: requests_per_month)
        expect_any_instance_of(Direction).not_to receive(:make_request)
        post :reply, params: params
      end
      it "sends a message if user makes a single request over the limit" do
        requests_per_month = 20
        user.update(requests_this_month: requests_per_month)
        expect_any_instance_of(Message).to receive(:send_message).with("+1" + user.phone_number, "You've exceeded the monthly limit of #{requests_per_month} direction requests this month")
        post :reply, params: params
      end
    end
    context "unregistered user" do
      let(:user) {build(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "From San Gabriel to Pasadena"}}
      before do
        response = double("direction_response")
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:valid_request?).and_return(true)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
        allow_any_instance_of(Message).to receive(:send_message).and_return(true)
      end
      it "doesn't make a google directions API request" do 
        expect_any_instance_of(Direction).not_to receive(:make_request)
        post :reply, params: params
      end
      it "doesn't send a text message" do
        expect_any_instance_of(Message).not_to receive(:send_message)
        post :reply, params: params
      end
    end
    context "invalid direction request" do
      let(:user) {create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel"}}
      before do
        response = double("direction_response")
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:valid_request?).and_return(false)
        allow_any_instance_of(Message).to receive(:send_message).and_return(true)
      end
      it "sends the user text notification of invalid request" do
        expect_any_instance_of(Message).to receive(:send_message).with(params[:From], "Invalid Request: Please reformat to <origin> to <destination>")
        post :reply, params: params
      end
    end
    context "with valid transit option" do
      let(:user) {create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel to Pasadena by walking"}}
      before do
        response = double("direction_response")
        allow(response).to receive(:make_request)
        allow(response).to receive(:valid_request?).and_return(true)
        allow(response).to receive(:process_and_format).and_return([[""]])
        direction_obj = allow(Direction).to receive(:new).and_return(response)
        allow_any_instance_of(Message).to receive(:send_message).and_return(true)
      end
      it "makes a google directions API request" do
        expect(Direction).to receive(:new).with({:origin=>"San+Gabriel", :destination=>"Pasadena", :time=>Time.now.getutc.to_i + 100, :travel_mode=>"walking"})
        post :reply, params: params
      end
      it "makes a figures out transit options when synonyms are used" do
        alt_params = {From: "+1" + user.phone_number, Body: "San Gabriel to Pasadena by foot"}
        expect(Direction).to receive(:new).with({:origin=>"San+Gabriel", :destination=>"Pasadena", :time=>Time.now.getutc.to_i + 100, :travel_mode=>"walking"})
        post :reply, params: alt_params
      end
    end
  end
end
  
