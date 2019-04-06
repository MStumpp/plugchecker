# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class NetworkRestriction < TariffPriceRestrictionBase
      attribute :value, Types::Strict::Array.of(Types::Strict::String)

      private

      def value_match?(_connector, station, _options)
        value.any? { |network| station.network == network }
      end
    end
  end
end
