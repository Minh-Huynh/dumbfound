class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  def reply
    formatted_phone_number = params[:From].gsub /^\+1/,""
    user = User.find_by(phone_number: formatted_phone_number)
    
    if user
      received_msg = params[:Body]
      from, to = parse_incoming_message(received_msg)
      msg = Direction.new(origin: from, destination: to, time: Time.now.getutc.to_i)
      response = msg.make_request.join(" / ")
      from_number = params["From"]
      account_sid = ENV["twilio_sid"]
      auth_token = ENV["twilio_token"]

      @client = Twilio::REST::Client.new account_sid, auth_token
      sms = @client.messages.create(
        from: ENV["twilio_number"],
        to: from_number,
        body: response
      )
    end
  end

  private
  def parse_incoming_message(msg)
    begin
      locations = msg.split("to")
      from = locations[0].gsub(/\s+/, "+")
      to = locations[1].gsub(/\s+/, "+")
      return from,to
    rescue
      false
    end
  end
end
