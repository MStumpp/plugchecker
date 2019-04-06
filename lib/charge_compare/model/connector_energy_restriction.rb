# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class ConnectorEnergyRestriction < TariffPriceRestrictionBase
      attribute :value, Types::ConnectorEnergy

      private

      def value_match?(connector, _station, _options)
        value == connector.energy
      end
    end
  end
end
