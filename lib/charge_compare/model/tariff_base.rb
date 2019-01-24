
require "types"
require "charge_compare/model/tariff_price"

module ChargeCompare
  module Model
    class TariffBase < Dry::Struct
      
      attribute :provider,   Types::Strict::String
      attribute :prices,     Types::Strict::Array.of(TariffPrice)
    end
  end
end