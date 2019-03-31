# frozen_string_literal: true

require "types"

module ChargeCompare
  module Model
    class Application < Dry::Struct
      attribute :api_key,       Types::Coercible::String
      attribute :name,          Types::Strict::String
      attribute :read_costs,    Types::Strict::Bool
      attribute :read_tariffs,  Types::Strict::Bool
      attribute :write_tariffs, Types::Strict::Bool
    end
  end
end
