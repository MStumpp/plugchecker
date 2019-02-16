# frozen_string_literal: true

require "types"
require "charge_compare/model/connector"

module ChargeCompare
  module Model
    class Station < Dry::Struct
      attribute :id,               Types::Strict::String
      attribute :name,             Types::Strict::String
      attribute :longitude,        Types::Coercible::Float
      attribute :latitude,         Types::Coercible::Float
      attribute :is_free_parking,  Types::Strict::Bool
      attribute :is_free_charging, Types::Strict::Bool
      attribute :charge_card_ids,  Types::Strict::Array.of(Types::Strict::String)
      attribute :region,           Types::Region
      attribute :connectors,       Types::Strict::Array.of(Connector)
      attribute :going_electric_url, Types::Strict::String
    end
  end
end
