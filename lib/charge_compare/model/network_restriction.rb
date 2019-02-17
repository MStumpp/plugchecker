# frozen_string_literal: true

require "charge_compare/model/tariff_price_restriction_base"

module ChargeCompare
  module Model
    class NetworkRestriction < TariffPriceRestrictionBase
      attribute :value, Types::Strict::Array.of(Types::Strict::String)
    end
  end
end
