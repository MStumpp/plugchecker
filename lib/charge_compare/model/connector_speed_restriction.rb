# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class ConnectorSpeedRestriction < TariffPriceRestrictionBase
      attribute :allowed_value, Types::Strict::Array.of(Types::Coercible::Float)
    end
  end
end
