# frozen_string_literal: true

module ChargeCompare
  module UseCase
    module ChargePrices
      class CalculatePriceForTariff
        attr_reader :station, :tariff, :options

        def initialize(station:, tariff:, options:)
          @station = station
          @tariff = tariff
          @options = options
        end

        def run
          considered_components = filter_components(tariff.prices)
          return if considered_components.empty? || !provider_customer_restriction_fulfilled?

          aggregate_components(considered_components)
        end

        private

        def filter_components(tariff_prices)
          tariff_prices.select do |tp|
            tp.restrictions.all? do |r|
              r.fulfilled?(selected_connector, station, options)
            end
          end
        end

        def provider_customer_restriction_fulfilled?
          !tariff.provider_customer_only ||
            (tariff.provider_customer_only && options.provider_customer_tariffs)
        end

        def aggregate_components(tariff_prices)
          tariff_prices.reduce(0) { |sum, tp| sum + component_price(tp) }
        end

        def component_price(tariff_price)
          tariff_price.decomposition.reduce(0) { |sum, seg| sum + seg.calculate_price(options) }
        end

        def selected_connector
          station.connectors[options.connector_index]
        end
      end
    end
  end
end
