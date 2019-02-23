# frozen_string_literal: true

require "charge_compare/model/flexible_price_tariff"
require "faraday"
require "haversine"
require "charge_compare/repository/concerns/flexible_provider_base"

module ChargeCompare
  module Repository
    module NewMotion
      module Strategy
        class Http < Concerns::FlexibleProviderBase
          SPEED_MAPPING = {
            3680  => 3.7,
            11040 => 11,
            22080 => 22,
            43470 => 43
          }.freeze

          AC_PHASE_MAPPING = {
            "AC1Phase" => 1,
            "AC3Phase" => 3
          }.freeze

          def fetch_matching_station_ids(station)
            lat = station.latitude
            lng = station.longitude

            coords = [
              lng - MATCHING_RADIUS,
              lng + MATCHING_RADIUS,
              lat - MATCHING_RADIUS,
              lat + MATCHING_RADIUS
            ]

            hash = request("api/map/v2/markers", *coords)
            valid_stations_by_distance(hash, lat, lng).map { |s| s[:locationUid] }
          end

          def valid_stations_by_distance(nm_stations, lat, lng)
            return [] if nm_stations.empty?

            nearest = nm_stations.min_by { |s| distance(s, lat, lng) }

            nearest_lat = nearest.dig(:coordinates, :latitude)
            nearest_lng = nearest.dig(:coordinates, :longitude)

            nm_stations.find_all { |s| distance(s, nearest_lat, nearest_lng) < SAME_STATION_RADIUS }
          end

          def distance(nm_station, lat, lng)
            lat1 = nm_station.dig(:coordinates, :latitude)
            lng1 = nm_station.dig(:coordinates, :longitude)
            Haversine.distance(lat1, lng1, lat, lng).to_meters
          end

          def fetch_provider_station_details(nm_station_ids)
            same_stations = find_same_stations(nm_station_ids)
            all_connectors = same_stations.map { |sd| sd[:evses].map { |h| h[:connectors] } }.flatten

            prices = all_connectors.map { |c| parse_prices_of_connector(c) }
            prices = prices.select { |p| p.decomposition.any? }.uniq
            prices.any? ? [new_model(prices)] : []
          end

          def find_same_stations(nm_station_ids)
            station_details = nm_station_ids.map { |st_id| request("api/map/v2/locations", st_id) }
            station_details.find_all { |sd| sd[:operatorName] == station_details.first[:operatorName] }
          end

          def parse_prices_of_connector(connector)
            speed = parse_speed(connector[:electricalProperties])
            restrictions = [
              Model::ConnectorSpeedRestriction.new(value: speeds_with_special_speed_handling(speed))
            ]
            segments = [minute_price_segment(connector), constant_price_segment(connector)]

            Model::TariffPrice.new(restrictions: restrictions, decomposition: segments.compact)
          end

          def minute_price_segment(connector)
            price = connector[:tariff][:perMinute]
            return unless price

            Model::LinearSegment.new(price: price, dimension: "minute")
          end

          def constant_price_segment(connector)
            price = connector[:tariff][:startFee]
            return unless price

            Model::ConstantSegment.new(price: price)
          end

          def parse_speed(elec_prop)
            speed = (elec_prop[:voltage] * elec_prop[:amperage])
            phases = AC_PHASE_MAPPING[elec_prop[:powerType]] || 1
            total_speed = speed * phases
            SPEED_MAPPING[total_speed] || total_speed / 1000
          end

          def speeds_with_special_speed_handling(speed)
            return [speed] if speed != 150

            [150, 350]
          end

          def model_defaults
            {
              provider: "New Motion",
              url:      "https://my.newmotion.com/"
            }
          end

          def request(*args)
            response = Faraday.new("https://my.newmotion.com").get File.join(args.map(&:to_s))
            raise Errors::ServiceUnavailable unless response.status == 200

            JSON.parse(response.body, symbolize_names: true)
          rescue Faraday::Error
            raise Errors::ServiceUnavailable
          end
        end
      end
    end
  end
end
