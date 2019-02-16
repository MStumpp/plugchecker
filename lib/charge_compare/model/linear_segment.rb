# frozen_string_literal: true

require "types"
require "charge_compare/model/tariff_price_segment_base"

module ChargeCompare
  module Model
    class LinearSegment < TariffPriceSegmentBase
      attribute :dimension, Types::PriceDimension
      attribute :range_gte, Types::Strict::Integer.optional.default(nil)
      attribute :range_lt,  Types::Strict::Integer.optional.default(nil)
    end
  end
end
