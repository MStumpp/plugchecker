# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class ConnectorEnergyRestriction < TariffPriceRestrictionBase
      attribute :allowed_value, Types::ConnectorEnergy
    end
  end
end
