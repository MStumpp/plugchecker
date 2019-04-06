# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class ConnectorSpeedRestriction < TariffPriceRestrictionBase
      attribute :value,           Types::Strict::Array.of(Types::Coercible::Float.optional)
      attribute :value_is_range,  Types::Strict::Bool.default(false)

      MAX_VALUE = 999999

      private

      def value_match?(connector, _station, _options)
        if value_is_range
          validate_range!
          connector.speed.between?(gte, lte)
        else
          value.any? { |v| v == connector.speed }
        end
      end

      def validate_range!
        return if value.length == 2 && gte < lte

        raise ArgumentError.new("invalid range #{value}")
      end

      def gte
        value[0] || 0
      end

      def lte
        value[1] || 999999
      end
    end
  end
end
