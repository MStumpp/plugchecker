
require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class ConnectorSpeedRestriction < TariffPriceRestrictionBase
      attribute :allowed_value,  Types::Strict::Array.of(Types::ConnectorSpeed)
    end
  end
end