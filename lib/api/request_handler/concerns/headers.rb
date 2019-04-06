# frozen_string_literal: true

module Api
  module RequestHandler
    module Concerns
      module Headers
        def headers
          request.env
                 .select { |e| e =~ /HTTP_.*/ }
                 .each_with_object({}) do |(raw_key, value), memo|
            key = raw_key.sub("HTTP_", "").downcase.to_sym
            memo[key] = value
          end
        end
      end
    end
  end
end
