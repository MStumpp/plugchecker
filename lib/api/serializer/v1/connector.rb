# frozen_string_literal: true

require "securerandom"
require "api/serializer/v1/base"

module Api
  module Serializer
    module V1
      class Connector < Base
        id { SecureRandom.uuid }
        type "connector"

        attribute :speed
        attribute :plug
        attribute :count
        attribute :energy
      end
    end
  end
end
