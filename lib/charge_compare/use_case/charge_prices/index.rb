# frozen_string_literal: true

require "charge_compare/use_case/concerns/authorization"
require "charge_compare/use_case/charge_prices/calculate_price_for_tariff"
require "charge_compare/use_case/tariffs/show"
require "charge_compare/model/charge_price"
require "charge_compare/data_adapter/going_electric"

module ChargeCompare
  module UseCase
    module ChargePrices
      class Index
        include Concerns::Authorization

        def initialize(dto)
          @dto = dto
        end

        def run
          authorize_app!(:read_costs)

          OpenStruct.new(charge_prices: fetch_charge_prices)
        end

        private

        attr_reader :dto

        def fetch_charge_prices
          fetch_tariffs.map { |t| generate_charge_price(t) }.select { |cp| cp.charge_point_prices.any? }
        end

        def generate_charge_price(tariff)
          connector_prices = station.connectors.each_with_object([]).with_index do |(con, memo), index|
            price = price_for_tariff(tariff, index)
            memo << con.to_h.merge(price: price) if price
          end

          build_charge_price_model(tariff, connector_prices)
        end

        def build_charge_price_model(tariff, charge_point_prices) # rubocop:disable Metrics/MethodLength
          Model::ChargePrice.new(
            tariff:                 tariff.try(:name),
            provider:               tariff.provider,
            url:                    tariff.url,
            monthly_min_sales:      tariff.monthly_min_sales,
            total_monthly_fee:      tariff.total_monthly_fee,
            is_flat_rate:           tariff.is_flat_rate,
            provider_customer_only: tariff.provider_customer_only,
            currency:               "eur",
            charge_point_prices:    charge_point_prices
          )
        end

        def fetch_tariffs
          body = merge_to_struct(station, charge_card_ids: charge_card_ids)
          Tariffs::Show.new(request: OpenStruct.new(body: body))
                       .run
                       .available_tariffs
        end

        def price_for_tariff(tariff, connector_index)
          opts = merge_to_struct(options, connector_index: connector_index)
          CalculatePriceForTariff.new(station: station, tariff: tariff, options: opts).run
        end

        def merge_to_struct(struct, vals)
          OpenStruct.new(struct.to_h.merge(vals))
        end

        def station
          mapped_dto.station
        end

        def options
          mapped_dto.options
        end

        def charge_card_ids
          mapped_dto.charge_card_ids
        end

        def mapped_dto
          @mapped_dto ||= DataAdapter::GoingElectric.map(dto.body)
        end
      end
    end
  end
end
