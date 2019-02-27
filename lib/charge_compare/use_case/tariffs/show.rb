# frozen_string_literal: true

require "charge_compare/repository/going_electric"
require "charge_compare/repository/plugsurfing"
require "charge_compare/repository/new_motion"
require "charge_compare/repository/fixed_price_tariff"
require "charge_compare/model/station_tariffs"
require "ostruct"

module ChargeCompare
  module UseCase
    module Tariffs
      class Show
        CHARGE_CARD_REPO_MAPPING = {
          "7"  => Repository::Plugsurfing,
          "8"  => Repository::Plugsurfing,
          "11" => Repository::NewMotion
        }.freeze

        NETWORK_CHARGE_CARD_ID_MAPPING = {
          "Tesla Supercharger" => "tesla"
        }.freeze

        attr_reader :request

        def initialize(request:)
          @request = request
        end

        def run
          station = request.body
          available_tariffs = collect_tariffs(station)
          Model::StationTariffs.new(available_tariffs: available_tariffs)
        end

        private

        def collect_tariffs(station)
          collect_fixed_price_tariffs(station) + collect_flexible_price_tariffs(station)
        end

        def collect_fixed_price_tariffs(station)
          station = OpenStruct.new(station.to_h.tap { |h| h[:charge_card_ids] << extra_ids(station) })
          Repository::FixedPriceTariff.where(station: station)
        end

        def extra_ids(station)
          cc_id = NETWORK_CHARGE_CARD_ID_MAPPING[station.network]
          cc_id ? [cc_id] : []
        end

        def collect_flexible_price_tariffs(station)
          station.charge_card_ids
                 .map { |cc_id| CHARGE_CARD_REPO_MAPPING[cc_id] }
                 .compact.uniq
                 .map { |r| r.where(station: station) }
                 .flatten
        end
      end
    end
  end
end
