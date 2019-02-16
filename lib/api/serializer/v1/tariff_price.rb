# frozen_string_literal: true

require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class TariffPrice < Base
        id { SecureRandom.uuid }
        type { "tariff_price" }

        RESTRICTIONS_TYPE_MAPPING = {
          "ChargeCompare::Model::ConnectorEnergyRestriction"  => "connector_energy",
          "ChargeCompare::Model::ConnectorSpeedRestriction"   => "connector_speed",
          "ChargeCompare::Model::RegionRestriction"           => "region",
          "ChargeCompare::Model::ProviderCustomerRestriction" => "provider_customer"
        }.freeze

        SEGMENT_TYPE_MAPPING = {
          "ChargeCompare::Model::LinearSegment"   => "linear",
          "ChargeCompare::Model::ConstantSegment" => "constant"
        }.freeze

        attribute :restrictions do
          @object.restrictions.map do |res|
            res.to_h.merge(metric: RESTRICTIONS_TYPE_MAPPING[res.class.to_s])
          end
        end

        attribute :decomposition do
          @object.decomposition.map do |seg|
            seg.to_h.merge(degree: SEGMENT_TYPE_MAPPING[seg.class.to_s])
          end
        end
      end
    end
  end
end
