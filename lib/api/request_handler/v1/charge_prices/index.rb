# frozen_string_literal: true

require "ostruct"
require "types"
require "errors"
require "api/request_handler/concerns/headers"

module Api
  module RequestHandler
    module V1
      module ChargePrices
        class Index
          include Concerns::Headers

          def initialize(request:)
            @request = request
          end

          attr_reader :request

          def to_dto
            OpenStruct.new(headers: headers, body: parse_body)
          rescue Dry::Types::ConstraintError, ArgumentError => ex
            raise Errors::RequestInvalid.new(ex)
          end

          def parse_body
            json_hash = MultiJson.load(request.body.read, symbolize_keys: true)
            attrs = json_hash.dig(:data, :attributes)

            validate_type!(json_hash)

            OpenStruct.new(
              station:         parse_station(attrs[:station]),
              options:         parse_options(attrs[:options]),
              data_adapter:    Types::DataAdapters[attrs[:data_adapter]],
              charge_card_ids: parse_charge_card_ids(attrs[:charge_card_ids])
            )
          end

          def validate_type!(json_hash)
            type = json_hash.dig(:data, :type)
            raise ArgumentError.new("invalid type") unless type == "charge_price_request"
          end

          def parse_station(attrs)
            OpenStruct.new(
              latitude:   Types::Strict::Float[attrs[:latitude]],
              longitude:  Types::Strict::Float[attrs[:longitude]],
              region:     attrs[:country],
              network:    attrs[:network],
              connectors: parse_connectors(attrs)
            )
          end

          def parse_connectors(attrs)
            (Types::Strict::Array[attrs[:charge_points]]).map do |c|
              OpenStruct.new(
                speed: Types::Coercible::Float[c[:power]],
                plug:  c[:plug]
              )
            end
          end

          def parse_options(attrs)
            OpenStruct.new(
              energy:                    Types::Coercible::Float[attrs[:energy]],
              duration:                  Types::Coercible::Float[attrs[:duration]],
              car_ac_phases:             Types::CarACPhases[attrs[:car_ac_phases] || 3],
              provider_customer_tariffs: Types::Strict::Bool[attrs[:provider_customer_tariffs] || false],
              currency:                  Types::Currencies[attrs[:currency] || "eur"]
            )
          end

          def parse_charge_card_ids(attrs)
            Types::Strict::Array[attrs]
            (attrs || []).map { |cc_id| Types::Strict::String[cc_id] }
          end
        end
      end
    end
  end
end
