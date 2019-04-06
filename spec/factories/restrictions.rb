# frozen_string_literal: true

require "charge_compare/model/connector_speed_restriction"
require "charge_compare/model/connector_energy_restriction"
require "charge_compare/model/car_ac_phases_restriction"
require "charge_compare/model/network_restriction"
require "charge_compare/model/region_restriction"

FactoryBot.define do
  factory :connector_speed_restriction, class: ChargeCompare::Model::ConnectorSpeedRestriction do
    value { [11, 22] }

    initialize_with { new(attributes) }
  end

  factory :connector_energy_restriction, class: ChargeCompare::Model::ConnectorEnergyRestriction do
    value { "ac" }

    initialize_with { new(attributes) }
  end

  factory :car_ac_phases_restriction, class: ChargeCompare::Model::CarACPhasesRestriction do
    value { 3 }

    initialize_with { new(attributes) }
  end

  factory :network_restriction, class: ChargeCompare::Model::NetworkRestriction do
    value { ["Energie Steiermark", "Wien Energie"] }

    initialize_with { new(attributes) }
  end

  factory :region_restriction, class: ChargeCompare::Model::RegionRestriction do
    value { %w[at de] }

    initialize_with { new(attributes) }
  end
end
