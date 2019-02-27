# frozen_string_literal: true

require "types"
require "charge_compare/model/station"
require "charge_compare/model/fixed_price_tariff"
require "charge_compare/model/flexible_price_tariff"

module ChargeCompare
  module Model
    class StationTariffs < Dry::Struct
      attribute :available_tariffs, Types::Array.of(TariffBase)
    end
  end
end
