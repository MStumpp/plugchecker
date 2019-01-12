require "pry"


require_relative "./compare_prices_of_station"
# require_relative "./plugsurfing"

# prices = Plugsurfing.new(station_details: nil).run
# details = FetchStationDetails.new(station_id: 26360).run
prices = ComparePricesOfStation.new(station_id: 17144).run

minutes = 60
kw = 10
speed = "11kW"

time_hour = minutes / 60.0

res = prices.map do |p|
  con = p[:prices].find { |c| c[:speed] == speed }
  next p unless con
  pc = con[:prices]
  p[:fee] = pc[:starting_fee] + pc[:parking_per_hour] * time_hour + pc[:charging_per_hour] * time_hour + pc[:charging_per_kwh] * kw
  p
end

binding.pry

a = 1

