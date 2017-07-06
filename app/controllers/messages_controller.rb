class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  STEPS_PER_SMS_MSG = 1
  REQUEST_LIMIT = 20 
  def reply
    formatted_phone_number = params[:From].gsub /^\+1/,""
    user = User.find_by(phone_number: formatted_phone_number)
    received_msg = params[:Body]
    if user && received_msg =~ / to / && user.requests_this_month < REQUEST_LIMIT
      from, to, travel_mode = parse_incoming_message(received_msg)
      directions = Direction.new(origin: from, destination: to, time: Time.now.getutc.to_i + 100, travel_mode: travel_mode)
      directions.make_request
      if directions.valid_request?
        directions.process_and_format(STEPS_PER_SMS_MSG).each do |steps|
          Message.new.send_message(params[:From],steps.join(" "))
          user.update(requests_this_month: user.requests_this_month + 1)
        end
      end
    elsif user && user.requests_this_month < REQUEST_LIMIT
      Message.new.send_message(params[:From], "Invalid Request: Please reformat to <origin> to <destination>")
    elsif user && user.requests_this_month == REQUEST_LIMIT 
      Message.new.send_message(params[:From], "You've exceeded the monthly limit of #{REQUEST_LIMIT} direction requests this month")
      user.update(requests_this_month: user.requests_this_month + 1)
    end
  end

  private
  def parse_incoming_message(msg)
    locations = msg.split(/to | by/)
    mode = locations.count == 3 ? locations[2] : nil
    from = locations[0].gsub(/\s+/, "+").chomp("+")
    to = locations[1].gsub(/\s+/, "+")
    return from,to, mode
  end
end
