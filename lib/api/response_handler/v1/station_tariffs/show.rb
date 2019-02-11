require 'jsonapi/serializable'
require "api/serializer/v1/station_tariffs"
require "api/serializer/v1/station"
require "api/serializer/v1/fixed_price_tariff"
require "api/serializer/v1/flexible_price_tariff"
require "api/serializer/v1/tariff_price"
require "api/serializer/v1/connector"

module Api
  module ResponseHandler
    module V1
      module StationTariffs
        class Show
          SERIALIZER_MAPPING = {
            "ChargeCompare::Model::StationTariffs": Api::Serializer::V1::StationTariffs,
            "ChargeCompare::Model::Station": Api::Serializer::V1::Station,
            "ChargeCompare::Model::FixedPriceTariff": Api::Serializer::V1::FixedPriceTariff,
            "ChargeCompare::Model::FlexiblePriceTariff": Api::Serializer::V1::FlexiblePriceTariff,
            "ChargeCompare::Model::TariffPrice": Api::Serializer::V1::TariffPrice,
            "ChargeCompare::Model::Connector": Api::Serializer::V1::Connector
          }
    
          def initialize(resource)
            @resource = resource
          end
    
          def to_rack_response
            [status, headers, [body]]
          end
    
          private
    
          attr_reader :resource
    
          def status
            200
          end
    
          def headers
           { 
             "Content-Type" => "application/json",
             "Access-Control-Allow-Origin" => "*"
            }
          end
    
          def body
            renderer = JSONAPI::Serializable::Renderer.new
            serialized_resource = renderer.render(
              resource,
              class: SERIALIZER_MAPPING,
              include: [:station, :available_tariffs, available_tariffs: [:prices], station: [:connectors]]
            )
    
            JSON.dump(serialized_resource)
          end
        end
      end
    end
  end
end