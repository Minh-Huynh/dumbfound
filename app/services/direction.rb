class Direction
 attr_accessor :token, :domain, :origin, :destination, :time, :travel_mode, :traffic_model

  def initialize(origin:, destination:, time:, travel_mode:)
    @token = ENV["google_maps_token"]
    @domain = "https://maps.googleapis.com/maps/api/directions"
    @origin = origin
    @destination = destination
    @time = time
    @traffic_model = "best_guess"
    @travel_mode = travel_mode
  end

  def make_request
    connection = Faraday.new domain do |conn|
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
    end
    @response = connection.post(query_string(origin: origin,
                                             destination: destination,
                                             time: time,
                                             travel_mode: travel_mode))
  end 

  def process_and_format(steps_per_chunk)
    if @response
      directions = @response.body["routes"].first["legs"].first["steps"].map.with_index do |step, index|
        ActionController::Base.helpers.strip_tags(step["html_instructions"]).prepend("#{index}) ")
      end
      directions.in_groups_of(steps_per_chunk)
    end
  end

  def query_string(origin:, destination:,time:, travel_mode:)
		"json?origin=#{origin}&destination=#{destination}&departure_time=#{time}&traffic_model=#{traffic_model}&travel_mode=#{travel_mode}&key=#{token}"
  end

  def valid_request?
    response.body["status"] == "OK"
  end
end
