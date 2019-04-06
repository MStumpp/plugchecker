# frozen_string_literal: true

require "types"
require "charge_compare/model/charge_point_price"

module ChargeCompare
  module Model
    class ChargePrice < Dry::Struct
      attribute :tariff,                 Types::Strict::String.optional
      attribute :provider,               Types::Strict::String
      attribute :url,                    Types::Strict::String
      attribute :monthly_min_sales,      Types::Coercible::Float.default(0.0)
      attribute :total_monthly_fee,      Types::Coercible::Float.default(0.0)
      attribute :is_flat_rate,           Types::Strict::Bool.default(false)
      attribute :provider_customer_only, Types::Strict::Bool.default(false)
      attribute :currency,               Types::Strict::String.default("eur")
      attribute :charge_point_prices, Types::Array.of(ChargePointPrice)
    end
  end
end
