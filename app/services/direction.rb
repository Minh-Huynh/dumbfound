class Direction
 attr_accessor :token, :domain, :origin, :destination, :time

  def initialize
    @token = ENV["google_maps_token"]
    @domain = "https://maps.googleapis.com/maps/api/directions"
  end

  def make_request(origin:, destination:, time:)
    connection = Faraday.new domain do |conn|
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
    end
    response = connection.post(query_string(origin: origin, destination: destination, time: time))
  end 

  def self.process_and_format(response, steps_per_chunk)
    directions = response.body["routes"].first["legs"].first["steps"].map.with_index do |step, index|
      ActionController::Base.helpers.strip_tags(step["html_instructions"]).prepend("#{index}) ")
    end
    directions.in_groups_of(steps_per_chunk)
  end

  def query_string(origin:, destination:,time:)
		"json?origin=#{origin}&destination=#{destination}&departure_time=#{time}&traffic_model=best_guess&key=#{token}"
  end

  def self.valid_request?(response)
    response.body["status"] == "OK"
  end
end
