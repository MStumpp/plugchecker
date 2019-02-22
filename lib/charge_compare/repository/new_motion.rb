# frozen_string_literal: true

require "receptacle"

require "charge_compare/repository/new_motion/strategy/http"

module ChargeCompare
  module Repository
    module NewMotion
      include Receptacle::Repo

      mediate :where

      strategy Strategy::Http
    end
  end
end
