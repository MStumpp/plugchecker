require "api/serializer/v1/tariff_base"

module Api
  module Serializer
    module V1
      class FlexiblePriceTariff < TariffBase
        type "flexible_price_tariff"

        attribute_timestamp :valid_at
      end
    end
  end
end