class Message
  attr_reader :from, :account_sid, :auth_token

  def initialize
    @from = ENV["twilio_number"]
    @account_sid = ENV["twilio_sid"]
    @auth_token = ENV["twilio_token"]
  end

  def send_message(receiving_number, message)
    client = Twilio::REST::Client.new account_sid, auth_token
    sms = client.messages.create(
      from: from,
      to: receiving_number,
      body: message
    )
  end

end

  
