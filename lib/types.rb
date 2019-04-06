# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry::Types.module

  ConnectorEnergy = Types::Strict::String.enum("ac", "dc")
  Region = Types::Strict::String.enum("at", "de", "ch", "nl", "sl", "hr", "it")
  Period = Types::Strict::String.enum("month", "year")
  PriceDimension = Types::Strict::String.enum("minute", "kwh")
  Allowance = Types::Strict::String.enum("allow", "deny")
  Currencies = Types::Strict::String.enum("eur")
  CarACPhases = Types::Strict::Integer.enum(1, 3)
  DataAdapters = Types::Strict::String.enum("going_electric")
end
