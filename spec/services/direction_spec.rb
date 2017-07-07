require "rails_helper"

RSpec.describe Direction do
  let(:by_car){ Direction.new(origin: "San Gabriel",
                             destination: "Pasadena, CA",
                             time: Time.now.getutc.to_i,
                             travel_mode: "driving")
  }
  let(:by_transit){Direction.new(origin: "San Gabriel",
                                 destination: "Pasadena, CA",
                                 time: Time.now.getutc.to_i,
                                 travel_mode: "transit")
  }
  describe "make request" , :vcr do
    it "returns directions" do
      response = by_car.make_request
      expect(response.body["status"]).to eq("OK")
    end

    it "gives different directions depending on transit" do
      car_directions = by_car.make_request
      transit_directions = by_transit.make_request
      expect(car_directions.body["routes"].first["summary"]).not_to eq(transit_directions.body["routes"].first["summary"])
    end
  end

  describe "query_string" do
    it "returns a proper query string" do
      by_car = Direction.new(origin: "San Gabriel",
                             destination: "Pasadena, CA",
                             time: Time.now.getutc.to_i,
                             travel_mode: "driving")
      expect(by_car.query_string).to eq("json?origin=#{by_car.origin}&destination=#{by_car.destination}&departure_time=#{by_car.time}&traffic_model=#{by_car.traffic_model}&mode=#{by_car.travel_mode}&key=#{by_car.token}")
    end
  end
end
  
