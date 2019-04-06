# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class ChargePointPrice < Dry::Struct
      attribute :energy, Types::Strict::String
      attribute :plug,   Types::Strict::String
      attribute :speed,  Types::Coercible::Float
      attribute :price,  Types::Coercible::Float
    end
  end
end
