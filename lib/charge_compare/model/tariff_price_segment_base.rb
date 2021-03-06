# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class TariffPriceSegmentBase < Dry::Struct
      attribute :price, Types::Coercible::Float
    end
  end
end
