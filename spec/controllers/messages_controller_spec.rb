require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  describe "Messages#reply" do
    context "valid registered user and valid request" do
      let(:user) {create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "From San Gabriel to Pasadena"}}
      before do
        response = double("direction_response")
        Direction.any_instance.stub(:make_request)
        Direction.any_instance.stub(:valid_request?).and_return(true)
        Direction.any_instance.stub(:process_and_format).and_return([[""]])
        Message.any_instance.stub(:send_message).and_return(true)
      end
      it "makes a google directions API request" do
        expect_any_instance_of(Direction).to receive(:make_request)
        post :reply, params: params
      end
      it "sends a text message to user phone number via Twilio" do
        expect_any_instance_of(Message).to receive(:send_message)
        post :reply, params: params
      end
    end
    context "unregistered user" do
      let(:user) {build(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "From San Gabriel to Pasadena"}}
      before do
        response = double("direction_response")
        Direction.any_instance.stub(:make_request)
        Direction.any_instance.stub(:valid_request?).and_return(true)
        Direction.any_instance.stub(:process_and_format).and_return([[""]])
        Message.any_instance.stub(:send_message).and_return(true)
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
        Direction.any_instance.stub(:make_request)
        Direction.any_instance.stub(:valid_request?).and_return(false)
        Message.any_instance.stub(:send_message).and_return(true)
      end
      it "sends the user text notification of invalid request" do
        expect_any_instance_of(Message).to receive(:send_message).with(params[:From], "Invalid Request: Please reformat to <origin> to <destination>")
        post :reply, params: params
      end
    end
    context "with valid transit option" do
      let(:user) {create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "From San Gabriel to Pasadena by walking"}}
      before do
        response = double("direction_response")
        response.stub(:make_request)
        response.stub(:valid_request?).and_return(true)
        response.stub(:process_and_format).and_return([[""]])
        direction_obj = Direction.stub(:new).and_return(response)
        Message.any_instance.stub(:send_message).and_return(true)
      end
      it "makes a google directions API request" do
        Direction.should_receive(:new).with({:origin=>"From+San+Gabriel", :destination=>"Pasadena", :time=>Time.now.getutc.to_i, :travel_mode=>" walking"})
        post :reply, params: params
      end
    end
  end
end
  
