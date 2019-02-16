# frozen_string_literal: true

require "jsonapi/serializable"

module Api
  module Serializer
    module V1
      class Base < JSONAPI::Serializable::Resource
        def self.attribute_timestamp(name, options = {})
          attribute(name, options) do
            @object[name].to_i * 1000 if @object[name]
          end
        end
      end
    end
  end
end
