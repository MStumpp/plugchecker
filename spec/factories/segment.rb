# frozen_string_literal: true

require "charge_compare/model/linear_segment"

FactoryBot.define do
  factory :linear_segment, class: ChargeCompare::Model::LinearSegment do
    price { 0.1 }
    dimension { "minute" }

    initialize_with { new(attributes) }
  end
end
