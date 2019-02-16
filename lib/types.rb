# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry::Types.module

  ConnectorEnergy = Types::Strict::String.enum("ac", "dc")
  Region = Types::Strict::String.enum("at", "de", "ch", "nl", "sl", "hr", "it")
  Period = Types::Strict::String.enum("month", "year")
  PriceDimension = Types::Strict::String.enum("minute", "kwh")
end
