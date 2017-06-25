class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    account_sid = ENV["twilio_sid"]
    auth_token = ENV["twilio_token"]
    @client = Twilio::REST::Client.new account_sid, auth_token
    sms = @client.messages.create(
      from: ENV["twilio_number"],
      to: from_number,
      body: "Directions will be sent here"
    )
  end
end
