class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'faraday_middleware'

  def reply
    formatted_phone_number = params[:From].gsub /^\+1/,""
    user = User.find_by(phone_number: formatted_phone_number)
    
    if user
      maps_token = ENV["google_maps_token"]
      received_msg = params[:Body]
      locations = received_msg.split("to")
      from = locations[0].gsub(/\s+/, "+")
      to = locations[1].gsub(/\s+/, "+")

      html_string = "json?origin=#{from}&destination=#{to}&departure_time=1541202457&traffic_model=best_guess&key=#{ENV['google_maps_token']}"
      connection = Faraday.new "https://maps.googleapis.com/maps/api/directions" do |conn|
        conn.response :json, :content_type => /\bjson$/
        conn.adapter Faraday.default_adapter
      end
      response = connection.post(html_string)
      msg = response.body["routes"].first["summary"]

      message_body = params["Body"]
      from_number = params["From"]
      account_sid = ENV["twilio_sid"]
      auth_token = ENV["twilio_token"]

      @client = Twilio::REST::Client.new account_sid, auth_token
      sms = @client.messages.create(
        from: ENV["twilio_number"],
        to: from_number,
        body: msg
      )
    end
  end
end
