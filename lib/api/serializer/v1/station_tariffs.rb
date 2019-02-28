# frozen_string_literal: true

require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class StationTariffs < Base
        id { SecureRandom.uuid }
        type "tariff"

        has_many :available_tariffs do
          linkage always: true
        end
      end
    end
  end
end
