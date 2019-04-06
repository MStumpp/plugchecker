# frozen_string_literal: true

require "jsonapi/serializable"
require "api/serializer/v1/charge_price"

module Api
  module ResponseHandler
    module V1
      module ChargePrices
        class Index
          SERIALIZER_MAPPING = {
            "ChargeCompare::Model::ChargePrice": Api::Serializer::V1::ChargePrice
          }.freeze

          def initialize(collection)
            @collection = collection
          end

          def to_rack_response
            [status, headers, [body]]
          end

          private

          attr_reader :collection

          def status
            200
          end

          def headers
            {
              "Content-Type"                => "application/vnd.api+json",
              "Access-Control-Allow-Origin" => "*"
            }
          end

          def body
            renderer = JSONAPI::Serializable::Renderer.new
            serialized_resource = renderer.render(
              collection,
              class: SERIALIZER_MAPPING
            )

            JSON.dump(serialized_resource)
          end
        end
      end
    end
  end
end
