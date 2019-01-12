require "json"
require "faraday"

class FetchStationDetails
  
    attr_reader :station_id

    def initialize(station_id:)
      @station_id = station_id
    end
  
    def run
      data = {
        ge_id: station_id,
        key: ""
      }

      response = connection.post("/chargepoints") do |req|
        req.body = URI.encode_www_form(data)
      end

      hash = JSON.parse(response.body, symbolize_names: true)
      hash[:chargelocations].first
    end

    def connection
      Faraday.new("https://api.goingelectric.de")
    end
  end