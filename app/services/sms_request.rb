class SMSRequest
  attr_reader :from, :body
  REQUEST_LIMIT = 20
  STEPS_PER_SMS_MSG = 20

  def initialize
    @from = from.gsub /^\+1/,""
    @body = body
    @user = User.find_by(phone_number: from)
  end

	def send_text_message
		if user_exists? && request_count_under_limit? && valid_direction_request?
		  from, to, travel_mode = parse_incoming_message(body)
      directions = Direction.new(origin: from, destination: to, time: Time.now.getutc.to_i + 100, travel_mode: travel_mode)
      directions.make_request
      if directions.status_ok?
				directions.process_and_format(STEPS_PER_SMS_MSG).each do |steps|
          Message.new.send_message(params[:From],steps.join(" "))
          user.update(requests_this_month: user.requests_this_month + 1)
        end
      end
    elsif user_exists? && !valid_direction_request
			Message.new.send_message("+1" + from, "Invalid Request: Please reformat to <origin> to <destination> by <travel_mode>")
    elsif user_exists? && request_count_at_limit
      Message.new.send_message("+1" + from, "You've exceeded the monthly limit of #{REQUEST_LIMIT} direction requests this month")
    end
    increment_user_request_counter
  end
  
  private
  def user_exists?
    !@user.nil?
  end

  def increment_user_request_counter
    user.requests_this_month = user.requests_this_month + 1
  end

  def request_count_under_limit?
    user.requests_this_month < REQUEST_LIMIT    
  end

  def request_count_at_limit?
    user.requests_this_month == REQUEST_LIMIT
  end

  def valid_direction_request?
    from =~ / to /
  end

  def parse_incoming_message
	 locations = body.split(/to | by/).map{|x| x.strip}
			input_mode = locations.count == 3 ? locations[2] : nil
			if ["bike","biking","bicycling"].include?(input_mode)
				mode = "bicycling"
			elsif ["transit","bus","metro","subway"].include?(input_mode)
				mode = "transit"
			elsif ["walking", "foot"].include?(input_mode)
				mode = "walking"
			else
				mode = "driving"
			end
			from = locations[0].gsub(/\s+/, "+").chomp("+")
			to = locations[1].gsub(/\s+/, "+")
			return from,to, mode
  end
end

  
