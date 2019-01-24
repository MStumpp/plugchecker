
require "charge_compare/model/tariff_base"

module ChargeCompare
  module Model
    class FlexiblePriceTariff < TariffBase
      
      attribute :valid_at,   Types::Strict::Time.optional.default(nil)
    end
  end
end