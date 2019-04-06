# frozen_string_literal: true

require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class ChargePrice < Base
        id { SecureRandom.uuid }
        type "charge_price"

        attribute :provider
        attribute :tariff
        attribute :monthly_min_sales
        attribute :total_monthly_fee
        attribute :is_flat_rate
        attribute :provider_customer_only
        attribute :currency
        attribute(:charge_point_prices) do
          @object.charge_point_prices.map do |v|
            {
              power: v.speed,
              plug:  v.plug,
              price: v.price
            }
          end
        end
      end
    end
  end
end
