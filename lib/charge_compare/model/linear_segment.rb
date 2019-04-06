# frozen_string_literal: true

require "types"
require "charge_compare/model/tariff_price_segment_base"

module ChargeCompare
  module Model
    class LinearSegment < TariffPriceSegmentBase
      attribute :dimension, Types::PriceDimension
      attribute :range_gte, Types::Strict::Integer.optional.default(nil)
      attribute :range_lt,  Types::Strict::Integer.optional.default(nil)

      MAX_VALUE = 999999

      def calculate_price(options)
        amount = amount_for_dimension(options)

        gte = range_gte || 0
        lt = range_lt || MAX_VALUE

        amount_in_range = amount <= gte ? 0 : [amount, lt].min - gte
        amount_in_range * price
      end

      def amount_for_dimension(options)
        case dimension
        when "kwh"
          options.energy
        when "minute"
          options.duration
        else
          raise ArgumentError.new("invalid dimension #{dimension}")
        end
      end
    end
  end
end
