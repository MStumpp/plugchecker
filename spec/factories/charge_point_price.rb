# frozen_string_literal: true

require "charge_compare/model/charge_point_price"

FactoryBot.define do
  factory :charge_point_price, class: ChargeCompare::Model::ChargePointPrice do
    energy { "dc" }
    speed { 22 }
    price { 2.5 }
    plug { "CCS" }

    initialize_with { new(attributes) }
  end
end
