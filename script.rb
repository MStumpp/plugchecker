require "pry"

ENV["ENVIRONMENT"] = "development"

require 'bundler' ; Bundler.require

require ::File.expand_path("../config/environment", __FILE__)

# require "charge_compare/repository/fixed_price_tariff"
# require "charge_compare/repository/plugsurfing"
# require "charge_compare/repository/going_electric"
#ChargeCompare::Repository::FixedPriceTariff.load


# tariffs = ChargeComtarpare::Repository::Plugsurfing.where(station: station)
# tariffs = ChargeCompare::Repository::GoingElectric.find_station(id: "26360")

require "charge_compare/use_case/station_tariffs/show"
ChargeCompare::Repository::FixedPriceTariff.load
res = ChargeCompare::UseCase::StationTariffs::Show.new(station_id: "17144").run

# require_relative "./compare_prices_of_station"
# # require_relative "./plugsurfing"

# # prices = Plugsurfing.new(station_details: nil).run
# # details = FetchStationDetails.new(station_id: 26360).run
# prices = ComparePricesOfStation.new(station_id: 17144).run

# minutes = 60
# kw = 10
# speed = "11kW"

# time_hour = minutes / 60.0

# res = prices.map do |p|
#   con = p[:prices].find { |c| c[:speed] == speed }
#   next p unless con
#   pc = con[:prices]
#   p[:fee] = pc[:starting_fee] + pc[:parking_per_hour] * time_hour + pc[:charging_per_hour] * time_hour + pc[:charging_per_kwh] * kw
#   p
# end

binding.pry

a = 1

