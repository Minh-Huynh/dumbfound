class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  def reply
    formatted_phone_number = params[:From].gsub /^\+1/,""
    user = User.find_by(phone_number: formatted_phone_number)
    
    if user
      received_msg = params[:Body]
      from, to = parse_incoming_message(received_msg)
      directions = Direction.new
      response = directions.make_request(origin: from, destination: to, time: Time.now.getutc.to_i)
      if Direction.valid_request?(response)
        Direction.process_and_format(response, 3).each do |steps|
          Message.new.send_message(params[:From],steps.join(" "))
        end
      end
    end
  end

  private
  def parse_incoming_message(msg)
    locations = msg.split("to")
    from = locations[0].gsub(/\s+/, "+").chomp("+")
    to = locations[1].gsub(/\s+/, "+")
    return from,to
  end
end
