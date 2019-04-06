# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class CarACPhasesRestriction < TariffPriceRestrictionBase
      attribute :value, Types::Strict::Integer

      private

      def value_match?(_connector, _station, options)
        value == options.car_ac_phases
      end
    end
  end
end
