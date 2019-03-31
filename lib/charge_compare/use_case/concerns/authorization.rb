# frozen_string_literal: true

require "errors"
require "charge_compare/repository/application"

module ChargeCompare
  module UseCase
    module Concerns
      module Authorization
        def authorize_app!(action)
          api_key = dto.headers[:api_key]

          raise Errors::Forbidden.new("api_key missing") unless api_key

          app = Repository::Application.find(api_key: api_key)
          return if app.respond_to?(action) && app[action]

          raise Errors::Forbidden.new("action #{action} not allowed")
        rescue Errors::NotFound
          raise Errors::Forbidden.new("api_key invalid")
        end
      end
    end
  end
end
