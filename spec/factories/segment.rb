# frozen_string_literal: true

require "charge_compare/model/linear_segment"
require "charge_compare/model/constant_segment"

FactoryBot.define do
  factory :linear_segment, class: ChargeCompare::Model::LinearSegment do
    price { 0.1 }
    dimension { "minute" }

    initialize_with { new(attributes) }
  end

  factory :constant_segment, class: ChargeCompare::Model::ConstantSegment do
    price { 1 }

    initialize_with { new(attributes) }
  end
end
