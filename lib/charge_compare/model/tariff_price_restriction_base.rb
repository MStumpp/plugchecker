# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class TariffPriceRestrictionBase < Dry::Struct
      attribute :allowance, Types::Allowance.optional.default("allow")
    end
  end
end
