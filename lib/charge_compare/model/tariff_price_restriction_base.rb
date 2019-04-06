# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class TariffPriceRestrictionBase < Dry::Struct
      attribute :allowance, Types::Allowance.optional.default("allow")

      def fulfilled?(connector, station, options)
        match = value_match?(connector, station, options)
        case allowance
        when "allow"
          match
        when "deny"
          !match
        else
          raise ArgumentError.new("invalid allowance #{allowance}")
        end
      end

      private

      def value_match?(_connector, _station, _options)
        raise NotImplementedError
      end
    end
  end
end
