# frozen_string_literal: true

require "charge_compare/model/flexible_price_tariff"
require "faraday"
require "haversine"
require "charge_compare/repository/concerns/flexible_provider_base"

module ChargeCompare
  module Repository
    module Plugsurfing
      module Strategy
        class Http < Concerns::FlexibleProviderBase
          def fetch_matching_station_ids(station)
            lat = station.latitude
            lng = station.longitude

            hash = request(
              "station-get-surface": {
                "min-lat":  lat - MATCHING_RADIUS, "max-lat":  lat + MATCHING_RADIUS,
                "min-long": lng - MATCHING_RADIUS, "max-long": lng + MATCHING_RADIUS
              }
            )

            valid_stations_by_distance(hash[:stations], lat, lng).map { |s| s[:id] }
          end

          def valid_stations_by_distance(ps_stations, lat, lng)
            return [] if ps_stations.empty?

            nearest = ps_stations.min_by { |s| distance(s, lat, lng) }

            nearest_lat = nearest[:latitude]
            nearest_lng = nearest[:longitude]

            ps_stations.find_all { |s| distance(s, nearest_lat, nearest_lng) < SAME_STATION_RADIUS }
          end

          def distance(ps_station, lat, lng)
            lat1 = ps_station[:latitude]
            lng1 = ps_station[:longitude]
            Haversine.distance(lat1, lng1, lat, lng).to_meters
          end

          def fetch_provider_station_details(ps_station_ids)
            same_stations = find_same_stations(ps_station_ids)

            prices = same_stations.map { |s| s[:connectors] }.flatten.map do |c|
              restrictions = [
                Model::ConnectorSpeedRestriction.new(value: [c[:speed].to_f])
              ]

              Model::TariffPrice.new(restrictions: restrictions, decomposition: parse_segments(c[:prices]))
            end

            prices = prices.select { |p| p.decomposition.any? }.uniq
            prices.any? ? [new_model(prices)] : []
          end

          def find_same_stations(ps_station_ids)
            station_details = request("station-get-by-ids" => { "station-ids": ps_station_ids })[:stations]
            station_details.find_all do |sd|
              sd[:"operator-company-id"] == station_details.first[:"operator-company-id"]
            end
          end

          def request(data)
            connection = Faraday.new("https://api.plugsurfing.com/api/v3/request")

            response = connection.post do |req|
              req.headers["Authorization"] = "key=#{ChargeCompareService.configuration.plugsurfing_api_key}"
              req.headers["Content-Type"] = "application/json"
              req.body = JSON.dump(data)
            end

            raise Errors::ServiceUnavailable unless response.status == 200

            JSON.parse(response.body, symbolize_names: true)
          rescue Faraday::Error
            raise Errors::ServiceUnavailable
          end

          def parse_segments(prices)
            segments = []

            return [] unless prices

            constant_price = prices[:"starting-fee"].to_f
            segments << Model::ConstantSegment.new(price: constant_price) if constant_price.positive?
            segments << linear_time_segment(prices)
            segments << linear_energy_price(prices)

            segments.compact
          end

          def linear_time_segment(prices)
            linear_time_price = (prices[:"parking-per-hour"].to_f + prices[:"charging-per-hour"].to_f) / 60.0
            return unless linear_time_price.positive?

            Model::LinearSegment.new(price: linear_time_price, dimension: "minute")
          end

          def linear_energy_price(prices)
            linear_energy_price = prices[:"charging-per-kwh"].to_f
            return unless linear_energy_price.positive?

            Model::LinearSegment.new(price: linear_energy_price, dimension: "kwh")
          end

          def model_defaults
            {
              provider: "Plugsurfing",
              url:      "https://www.plugsurfing.com"
            }
          end
        end
      end
    end
  end
end
