# frozen_string_literal: true

require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class Station < Base
        type "station"

        attribute :name
        attribute :network
        attribute :longitude
        attribute :latitude
        attribute :is_free_parking
        attribute :is_free_charging
        attribute :price_description
        attribute :region
        attribute :going_electric_url

        has_many :connectors do
          linkage always: true
        end
      end
    end
  end
end
