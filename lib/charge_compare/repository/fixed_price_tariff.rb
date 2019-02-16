# frozen_string_literal: true

require "receptacle"

require "charge_compare/repository/fixed_price_tariff/strategy/in_memory"

module ChargeCompare
  module Repository
    module FixedPriceTariff
      include Receptacle::Repo

      mediate :where
      mediate :load

      strategy Strategy::InMemory
    end
  end
end
