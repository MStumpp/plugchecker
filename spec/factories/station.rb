# frozen_string_literal: true

require "charge_compare/model/station"

FactoryBot.define do
  factory :station, class: ChargeCompare::Model::Station do
    id { SecureRandom.uuid }
    name { "Billa" }
    network { "Smatrics" }
    longitude { 12.345 }
    latitude { 43.456 }
    is_free_parking { true }
    is_free_charging { true }
    charge_card_ids { ["123"] }
    region { "at" }
    connectors { [build(:connector)] }
    going_electric_url { "http://test.at" }
    price_description { "Ask at the shop." }

    initialize_with { new(attributes) }
  end
end
