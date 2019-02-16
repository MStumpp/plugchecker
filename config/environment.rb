# frozen_string_literal: true

require "active_support/all"
require "ostruct"

$LOAD_PATH.unshift(File.expand_path("..", __dir__))
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "dotenv/load"
env = ENV["ENVIRONMENT"]
Dotenv.load("config/.env.#{env}")

ChargeCompareService = OpenStruct.new(
  configuration: OpenStruct.new(
    plugsurfing_api_key:    ENV.fetch("PLUGSURFING_KEY"),
    going_electric_api_key: ENV.fetch("GOING_ELECTRIC_KEY")
  )
)

require "charge_compare/repository/fixed_price_tariff"

ChargeCompare::Repository::FixedPriceTariff.load
