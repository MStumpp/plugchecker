# frozen_string_literal: true

require "types"
require "charge_compare/model/connector_energy_restriction"
require "charge_compare/model/connector_speed_restriction"
require "charge_compare/model/provider_customer_restriction"
require "charge_compare/model/network_restriction"
require "charge_compare/model/car_ac_phases_restriction"
require "charge_compare/model/region_restriction"
require "charge_compare/model/constant_segment"
require "charge_compare/model/linear_segment"

module ChargeCompare
  module Model
    class TariffPrice < Dry::Struct
      attribute :restrictions,  Types::Strict::Array.of(TariffPriceRestrictionBase).default([])
      attribute :decomposition, Types::Strict::Array.of(TariffPriceSegmentBase)
    end
  end
end
