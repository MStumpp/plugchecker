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
    plugsurfing_api_key:  ENV.fetch("PLUGSURFING_KEY"),
    application_sheet_id: ENV.fetch("APPLICATION_SHEET_ID")
  )
)

require "multi_json"

require "charge_compare/repository/fixed_price_tariff"
require "charge_compare/repository/application"

ChargeCompare::Repository::FixedPriceTariff.load

# ChargeCompare::Repository::Application.load if env != "test"
