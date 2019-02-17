# frozen_string_literal: true

require "types"
require "charge_compare/model/tariff_price"

module ChargeCompare
  module Model
    class TariffBase < Dry::Struct
      attribute :provider,          Types::Strict::String
      attribute :url,               Types::Strict::String
      attribute :prices,            Types::Strict::Array.of(TariffPrice)
      attribute :monthly_min_sales, Types::Coercible::Float.default(0.0)
      attribute :monthly_fee,       Types::Coercible::Float.default(0.0)
      attribute :is_flat_rate, Types::Strict::Bool.default(false)
    end
  end
end
