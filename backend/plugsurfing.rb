
require "faraday"

class Plugsurfing

  attr_reader :station_details

  def initialize(station_details:, key: nil)
    @station_details = station_details
  end

  def run
    id = fetch_matching_station_id
    return unless id
    fetch_provider_station_details(id)
  end

  def fetch_matching_station_id

    # lat = 47.399364
    # lng =  13.6909

    lat = station_details[:coordinates][:lat]
    lng = station_details[:coordinates][:lng]
    delta = 0.01

    data = {
      "station-get-surface":{
        "min-lat": lat - delta,
        "max-lat": lat + delta,
        "min-long": lng - delta,
        "max-long": lng + delta
      }
    }

    response = connection.post do |req|
      req.headers["Authorization"] = ""
      req.headers["Content-Type"] = "application/json"
      req.body = JSON.dump(data)
    end

    hash = JSON.parse(response.body,symbolize_names: true)

    sorted_stations = hash[:stations].sort_by do |st|
      (st[:latitude] - lat)**2 + (st[:longitude] - lng)**2 
    end
    return if sorted_stations.empty?
    sorted_stations.first[:id]
  end

  def fetch_provider_station_details(station_id)
    data = {"station-get-by-ids":{"station-ids":[station_id]}}

    response = connection.post do |req|
      req.headers["Authorization"] = ""
      req.headers["Content-Type"] = "application/json"
      req.body = JSON.dump(data)
    end

    hash = JSON.parse(response.body,symbolize_names: true)
    all_connectors = hash[:stations].first[:connectors].map do |c|
      pr = c[:prices]
      {
        name: c[:name],
        speed: c[:speed],
        prices: {
          starting_fee: pr[:"starting-fee"].to_f, 
          parking_per_hour: pr[:"parking-per-hour"].to_f, 
          charging_per_hour: pr[:"charging-per-hour"].to_f,
          charging_per_kwh: pr[:"charging-per-kwh"].to_f
        }
      }
    end

    all_connectors.uniq
  end

  def connection
    Faraday.new("https://api.plugsurfing.com/api/v3/request")
  end
end