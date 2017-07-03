class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  STEPS_PER_SMS_MSG = 5

  def reply
    formatted_phone_number = params[:From].gsub /^\+1/,""
    user = User.find_by(phone_number: formatted_phone_number)
    received_msg = params[:Body]
    
    if user && received_msg =~ / to /
      from, to, travel_mode = parse_incoming_message(received_msg)
      directions = Direction.new(origin: from, destination: to, time: Time.now.getutc.to_i + 100, travel_mode: travel_mode)
      directions.make_request
      if directions.valid_request?
        directions.process_and_format(STEPS_PER_SMS_MSG).each do |steps|
          Message.new.send_message(params[:From],steps.join(" "))
        end
      end
    elsif user
      Message.new.send_message(params[:From], "Invalid Request: Please reformat to <origin> to <destination>")
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
