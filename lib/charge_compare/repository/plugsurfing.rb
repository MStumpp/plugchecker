
require "receptacle"

require "charge_compare/repository/plugsurfing/strategy/http"

module ChargeCompare
  module Repository
    module Plugsurfing
      include Receptacle::Repo

      mediate :where
      
      strategy Strategy::Http
    end
  end
end