class Direction
 attr_accessor :token, :domain, :origin, :destination, :time, :travel_mode, :traffic_model

  def initialize(origin:, destination:, time:, travel_mode:)
    @token = ENV["google_maps_token"]
    @domain = "https://maps.googleapis.com/maps/api/directions"
    @origin = origin.strip
    @destination = destination.strip
    @time = time
    @traffic_model = "best_guess"
    @travel_mode = travel_mode.nil? ? nil : travel_mode.strip
  end

  def make_request
    connection = Faraday.new domain do |conn|
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
    end
    @response = connection.post(query_string)
  end 

  def process_and_format(steps_per_text_message)
    if @response
      directions = direction_steps.map.with_index do |step, index|
        instructions = sanitize_url_encoding(step) 
        if step["travel_mode"] == "TRANSIT"
          instructions << add_transit_details(step)
        else
          instructions << "(" + step["distance"]["text"] + ")" if step["distance"]
        end
        instructions.prepend(" \##{index + 1}: ")
      end
      directions.in_groups_of(steps_per_text_message)
    end
  end

  def status_ok?
    @response.body["status"] == "OK"
  end
  
  private
  def sanitize_url_encoding(step)
        ActionController::Base.helpers.strip_tags(step["html_instructions"]).gsub /&amp;/, "&"
  end

  def add_transit_details(step)
    result_string = ""
    transit_details = step["transit_details"]
    result_string << " Headsign: \"" + transit_details["headsign"] + "\"" if transit_details.has_key?("headsign")
    result_string << " Line: " + transit_details["line"]["short_name"] if transit_details["line"].has_key?("short_name")
    result_string << " (" + step["duration"]["text"] + ")" if step["distance"]
    result_string << " Get off @ " + transit_details["arrival_stop"]["name"] if transit_details["arrival_stop"]
    result_string
  end
  

  def query_string
		"json?origin=#{origin}&destination=#{destination}&departure_time=#{time}&traffic_model=#{traffic_model}&mode=#{travel_mode}&key=#{token}"
  end

  def direction_steps
    begin
      @response.body["routes"].first["legs"].first["steps"]
    rescue
      false
    end
  end
end
