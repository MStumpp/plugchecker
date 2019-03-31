# frozen_string_literal: true

require "charge_compare/model/application"

FactoryBot.define do
  factory :application, class: ChargeCompare::Model::Application do
    api_key { SecureRandom.uuid }
    name { "Plugchecker" }
    read_costs { true }
    read_tariffs { true }
    write_tariffs { true }

    initialize_with { new(attributes) }

    to_create do |instance|
      ChargeCompare::Repository::Application.create(application: instance)
    end
  end
end
