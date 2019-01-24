
require "charge_compare/model/tariff_base"

module ChargeCompare
  module Model
    class FixedPriceTariff < TariffBase
      
      attribute :valid_from,  Types::Strict::Time.optional.default(nil)
      attribute :valid_to,    Types::Strict::Time.optional.default(nil)
      attribute :name,       Types::Strict::String
    end
  end
end