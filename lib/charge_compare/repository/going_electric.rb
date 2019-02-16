# frozen_string_literal: true

require "receptacle"

require "charge_compare/repository/going_electric/strategy/http"

module ChargeCompare
  module Repository
    module GoingElectric
      include Receptacle::Repo

      mediate :find_station

      strategy Strategy::Http
    end
  end
end
