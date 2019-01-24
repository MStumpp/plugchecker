require "charge_compare/repository/going_electric"
require "charge_compare/repository/plugsurfing"
require "charge_compare/repository/fixed_price_tariff"
require "charge_compare/model/station_tariffs"

module ChargeCompare
  module UseCase
    module StationTariffs
      class Show

        CHARGE_CARD_ID_MAPPING = {
          "7" => Repository::Plugsurfing,
          "8" => Repository::Plugsurfing
        }

        attr_reader :station_id

        def initialize(station_id: )
          @station_id = station_id
        end

        def run
          station = fetch_station_details
          available_tariffs = collect_tariffs(station)
          Model::StationTariffs.new(station: station, available_tariffs: available_tariffs)
        end

        private

        def fetch_station_details
          Repository::GoingElectric.find_station(id: station_id)
        end

        def collect_tariffs(station)
          collect_fixed_price_tariffs(station) +  collect_flexible_price_tariffs(station)          
        end

        def collect_fixed_price_tariffs(station)
          Repository::FixedPriceTariff.where(station: station)
        end

        def collect_flexible_price_tariffs(station)
          station.charge_card_ids.map do |cc_id|
            repository = CHARGE_CARD_ID_MAPPING[cc_id]
            next unless repository
            repository.where(station: station)
          end.compact
        end
      end
    end
  end
end