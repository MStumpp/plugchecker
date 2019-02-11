require "api/serializer/v1/tariff_base"

module Api
  module Serializer
    module V1
      class FixedPriceTariff < TariffBase
        type "fixed_price_tariff"

        attribute :name
        attribute :url
        attribute_timestamp :valid_from
        attribute_timestamp :valid_to
      end
    end
  end
end