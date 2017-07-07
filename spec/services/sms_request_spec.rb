require "rails_helper"

RSpec.describe SMSRequest do
  describe "make request" do
    context "when valid user/request/under limit" do
      let(:user){create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel to Pasadena, CA"}}
      before do
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:status_ok?).and_return(true)
        allow_any_instance_of(Message).to receive(:send_message)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
      end
      it "increments the user request count" do
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
        expect(user.reload.requests_this_month).to eq(1)
      end
      it "makes the message request" do
        expect_any_instance_of(Message).to receive(:send_message)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
      it "makes the direction request" do
        expect_any_instance_of(Direction).to receive(:make_request)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
    end
    context "when invalid user" do
      let(:user){build(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel to Pasadena, CA"}}
      before do
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:status_ok?).and_return(true)
        allow_any_instance_of(Message).to receive(:send_message)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
      end
      it "does not make the message request" do
        expect_any_instance_of(Message).not_to receive(:send_message)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
      it "does not make the direction request" do
        expect_any_instance_of(Direction).not_to receive(:make_request)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
    end
    context "when invalid incoming message" do
      let(:user){create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel Pasadena, CA"}}
      before do
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:status_ok?).and_return(true)
        allow_any_instance_of(Message).to receive(:send_message)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
      end
      it "sends a message alerting user of proper format" do
        expect_any_instance_of(Message).to receive(:send_message).with("+1" + user.phone_number, "Invalid Request: Please reformat to <origin> to <destination> by <travel_mode>")
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
      it "does not make the direction request" do
        expect_any_instance_of(Direction).not_to receive(:make_request)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
    end
    context "when user is over the monthly limit" do
      let(:user){create(:user)}
      let(:params){{From: "+1" + user.phone_number, Body: "San Gabriel to Pasadena, CA"}}
      before do
        allow_any_instance_of(Direction).to receive(:make_request)
        allow_any_instance_of(Direction).to receive(:status_ok?).and_return(true)
        allow_any_instance_of(Message).to receive(:send_message)
        allow_any_instance_of(Direction).to receive(:process_and_format).and_return([[""]])
        user.update(requests_this_month: SMSRequest::REQUEST_LIMIT)
      end
      it "sends a message alerting user of exceeding monthly limit" do
        expect_any_instance_of(Message).to receive(:send_message).with("+1" + user.phone_number, "You've exceeded the monthly limit of #{SMSRequest::REQUEST_LIMIT} direction requests this month")
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
      it "does not make the direction request" do
        expect_any_instance_of(Direction).not_to receive(:make_request)
        SMSRequest.new(from: params[:From], message: params[:Body]).send_text_message
      end
    end
  end
end
  
