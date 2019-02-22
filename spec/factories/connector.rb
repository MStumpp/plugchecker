# frozen_string_literal: true

require "charge_compare/model/connector"

FactoryBot.define do
  factory :connector, class: ChargeCompare::Model::Connector do
    speed { 50.0 }
    plug { "CCS" }
    count { 2 }

    initialize_with { new(attributes) }
  end
end
