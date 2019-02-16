# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class Connector < Dry::Struct
      attribute :speed,            Types::Coercible::Float
      attribute :plug,             Types::Strict::String
      attribute :count,            Types::Strict::Integer

      DC_PLUGS = ["CCS", "CHAdeMO", "Tesla Supercharger", "Tesla HPC"].freeze

      def energy
        DC_PLUGS.include?(plug) ? "dc" : "ac"
      end
    end
  end
end
