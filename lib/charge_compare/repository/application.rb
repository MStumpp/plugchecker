# frozen_string_literal: true

require "receptacle"

require "charge_compare/repository/application/strategy/in_memory"

module ChargeCompare
  module Repository
    module Application
      include Receptacle::Repo

      mediate :find
      mediate :load

      strategy Strategy::InMemory
    end
  end
end
