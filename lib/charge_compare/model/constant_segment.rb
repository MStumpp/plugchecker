# frozen_string_literal: true

require "types"
require "charge_compare/model/tariff_price_segment_base"

module ChargeCompare
  module Model
    class ConstantSegment < TariffPriceSegmentBase
      def calculate_price(_options)
        price
      end
    end
  end
end
