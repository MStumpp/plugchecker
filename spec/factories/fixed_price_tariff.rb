# frozen_string_literal: true

require "charge_compare/model/flexible_price_tariff"

FactoryBot.define do
  factory :fixed_price_tariff, class: ChargeCompare::Model::FlexiblePriceTariff do
    valid_from { Time.now.utc }
    valid_to { nil }
    name { "Standard" }
    provider { "Plugsurfing" }
    url { "http://test.at" }
    monthly_min_sales { 0.0 }
    monthly_fee { 0.0 }
    is_flat_rate { false }

    prices { [build(:tariff_price)] }

    initialize_with { new(attributes) }
  end
end
