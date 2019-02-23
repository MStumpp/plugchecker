# frozen_string_literal: true

require "errors"

module ChargeCompare
  module Repository
    module Concerns
      class FlexibleProviderBase
        MATCHING_RADIUS = 0.1
        SAME_STATION_RADIUS = 15

        def where(station:)
          station_ids = fetch_matching_station_ids(station)
          return [] if station_ids.empty?

          fetch_provider_station_details(station_ids)
        rescue Errors::ServiceUnavailable
          []
        end

        def new_model(prices)
          Model::FlexiblePriceTariff.new(
            valid_at: Time.now.utc,
            prices:   prices,
            **model_defaults
          )
        end
      end
    end
  end
end
