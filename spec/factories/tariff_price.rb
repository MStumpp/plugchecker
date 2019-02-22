# frozen_string_literal: true

require "charge_compare/model/flexible_price_tariff"

FactoryBot.define do
  factory :tariff_price, class: ChargeCompare::Model::TariffPrice do
    restrictions { [] }
    decomposition { [] }

    initialize_with { new(attributes) }
  end
end
