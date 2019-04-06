# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class RegionRestriction < TariffPriceRestrictionBase
      attribute :value, Types::Strict::Array.of(Types::Region)

      private

      def value_match?(_connector, station, _options)
        value.any? { |region| station.region == region }
      end
    end
  end
end
