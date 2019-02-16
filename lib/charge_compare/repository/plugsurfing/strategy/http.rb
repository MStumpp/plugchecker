# frozen_string_literal: true

require "charge_compare/model/flexible_price_tariff"

module ChargeCompare
  module Repository
    module Plugsurfing
      module Strategy
        class Http
          MATCHING_RADIUS = 0.1

          PROVIDER_NAME = "PlugSurfing"

          def where(station:)
            ps_station_id = fetch_matching_station_id(station)
            return [] unless ps_station_id

            fetch_provider_station_details(ps_station_id)
          end

          def fetch_matching_station_id(station)
            lat = station.latitude
            lng = station.longitude

            data = {
              "station-get-surface": {
                "min-lat":  lat - MATCHING_RADIUS,
                "max-lat":  lat + MATCHING_RADIUS,
                "min-long": lng - MATCHING_RADIUS,
                "max-long": lng + MATCHING_RADIUS
              }
            }

            hash = request(data)
            sorted_stations = hash[:stations].sort_by do |st|
              (st[:latitude] - lat)**2 + (st[:longitude] - lng)**2
            end

            return if sorted_stations.empty?

            sorted_stations.first[:id]
          end

          def fetch_provider_station_details(station_id)
            hash = request("station-get-by-ids" => { "station-ids": [station_id] })

            prices = hash[:stations].first[:connectors].map do |c|
              restrictions = [
                Model::ConnectorSpeedRestriction.new(allowed_value: [c[:speed].to_f])
              ]

              Model::TariffPrice.new(restrictions: restrictions, decomposition: parse_segments(c[:prices]))
            end

            prices = prices.select { |p| p.decomposition.any? }

            model = Model::FlexiblePriceTariff.new(
              provider: PROVIDER_NAME,
              url:      "https://www.plugsurfing.com",
              valid_at: Time.now.utc,
              prices:   prices.uniq
            )

            model.prices.any? ? [model] : []
          end

          def parse_segments(prices)
            segments = []

            return [] unless prices

            constant_price = prices[:"starting-fee"].to_f
            segments << Model::ConstantSegment.new(price: constant_price) if constant_price > 0

            linear_time_price = (prices[:"parking-per-hour"].to_f + prices[:"charging-per-hour"].to_f) / 60.0
            if linear_time_price > 0
              segments << Model::ConstantSegment.new(
                price:     linear_time_price,
                dimension: "minute"
              )
            end

            linear_energy_price = prices[:"charging-per-kwh"].to_f
            if linear_energy_price > 0
              segments << Model::ConstantSegment.new(
                price:     linear_energy_price,
                dimension: "kwh"
              )
            end

            segments
          end

          def request(data)
            connection = Faraday.new("https://api.plugsurfing.com/api/v3/request")

            response = connection.post do |req|
              req.headers["Authorization"] = "key=#{ChargeCompareService.configuration.plugsurfing_api_key}"
              req.headers["Content-Type"] = "application/json"
              req.body = JSON.dump(data)
            end

            JSON.parse(response.body, symbolize_names: true)
          end
        end
      end
    end
  end
end
