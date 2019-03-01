# frozen_string_literal: true

require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class TariffBase < Base
        id { SecureRandom.uuid }

        attribute :provider
        attribute :url
        attribute :monthly_min_sales
        attribute :monthly_fee
        attribute :is_flat_rate
        attribute :provider_customer_only

        has_many :prices do
          linkage always: true
        end
      end
    end
  end
end
