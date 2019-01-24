require 'dry-struct'

module Types
  include Dry::Types.module

  ConnectorEnergy = Types::Strict::String.enum('ac', 'dc')
  ConnectorSpeed = Types::Strict::String.enum('3.7kw', '11kw','22kw','43kw','50kw')
  Region = Types::Strict::String.enum('at', 'de','ch','nl','sl','hr','it')
  Period = Types::Strict::String.enum('month', 'year')
  PriceDimension = Types::Strict::String.enum('minute', 'kwh')
end