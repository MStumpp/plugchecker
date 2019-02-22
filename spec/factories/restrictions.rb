# frozen_string_literal: true

require "charge_compare/model/connector_speed_restriction"

FactoryBot.define do
  factory :connector_speed_restriction, class: ChargeCompare::Model::ConnectorSpeedRestriction do
    value { [11, 22] }

    initialize_with { new(attributes) }
  end
end
