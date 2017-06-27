class Direction
 attr_accessor :token, :domain, :origin, :destination, :time

  def initialize(origin:, destination:, time:)
    @token = ENV["google_maps_token"]
    @domain = "https://maps.googleapis.com/maps/api/directions"
    @origin = origin
    @destination = destination
    @time = time
  end

  def make_request
    connection = Faraday.new domain do |conn|
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
    end
    response = connection.post(query_string)
    byebug
    directions = response.body["routes"].first["legs"].first["steps"].map do |step|
      ActionController::Base.helpers.strip_tags(step["html_instructions"])
    end
    directions
  end 

  def query_string
		"json?origin=#{origin}&destination=#{destination}&departure_time=#{time}&traffic_model=best_guess&key=#{token}"
  end
end
