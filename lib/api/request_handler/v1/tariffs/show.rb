# frozen_string_literal: true

require "ostruct"
require "types"
require "errors"

module Api
  module RequestHandler
    module V1
      module Tariffs
        class Show
          def initialize(request:)
            @request = request
          end

          attr_reader :request

          def to_dto
            OpenStruct.new(body: parsed_body)
          rescue StandardError => ex
            raise Errors::RequestInvalid.new(ex)
          end

          def parsed_body
            json_hash = MultiJson.load(request.body.read, symbolize_keys: true)
            attrs = json_hash.dig(:data, :attributes)
            OpenStruct.new(
              latitude:        Types::Strict::Float[attrs[:latitude]],
              longitude:       Types::Strict::Float[attrs[:longitude]],
              region:          attrs[:region],
              network:         attrs[:network],
              charge_card_ids: parse_charge_card_ids(attrs),
              connectors:      parse_connectors(attrs)
            )
          end

          def parse_connectors(attrs)
            (attrs[:connectors] || []).map do |c|
              OpenStruct.new(
                speed:  Types::Coercible::Float[c[:speed]],
                energy: Types::ConnectorEnergy[c[:energy]]
              )
            end
          end

          def parse_charge_card_ids(attrs)
            (attrs[:charge_card_ids] || []).map { |cc_id| Types::Strict::String[cc_id] }
          end
        end
      end
    end
  end
end
