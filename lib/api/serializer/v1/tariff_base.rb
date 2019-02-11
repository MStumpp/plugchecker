require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class TariffBase < Base
        id { SecureRandom.uuid }

        attribute :provider
        attribute :url

        has_many :prices do
          linkage always: true
        end
      end
    end
  end
end