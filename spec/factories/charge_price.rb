# frozen_string_literal: true

require "charge_compare/model/charge_price"

FactoryBot.define do
  factory :charge_price, class: ChargeCompare::Model::ChargePrice do
    tariff { "Standard" }
    provider { "Plugsurfing" }
    url { "http://test.at" }
    monthly_min_sales { 0.0 }
    total_monthly_fee { 0.0 }
    is_flat_rate { false }
    provider_customer_only { false }
    currency { "eur" }
    charge_point_prices { [build(:charge_point_price)] }

    initialize_with { new(attributes) }
  end
end
