# frozen_string_literal: true

require "types"
require "charge_compare/model/tariff_price"

module ChargeCompare
  module Model
    class TariffBase < Dry::Struct
      attribute :provider,               Types::Strict::String
      attribute :url,                    Types::Strict::String
      attribute :prices,                 Types::Strict::Array.of(TariffPrice)
      attribute :monthly_min_sales,      Types::Coercible::Float.default(0.0)
      attribute :monthly_fee,            Types::Coercible::Float.default(0.0)
      attribute :yearly_service_fee,     Types::Coercible::Float.default(0.0)
      attribute :is_flat_rate,           Types::Strict::Bool.default(false)
      attribute :provider_customer_only, Types::Strict::Bool.default(false)

      def total_monthly_fee
        monthly_fee + yearly_service_fee / 12.0
      end
    end
  end
end
