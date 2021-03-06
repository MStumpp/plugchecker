# frozen_string_literal: true

module Api
  module ResponseHandler
    class Error
      ERROR_MAPPING = {
        "Errors::RequestInvalid" => 400
      }.freeze

      def initialize(error)
        @error = error
      end

      def to_rack_response
        [status, headers, [body]]
      end

      private

      attr_reader :error

      def status
        ERROR_MAPPING[error.class.to_s] || 500
      end

      def headers
        {
          "Content-Type"                => "application/json",
          "Access-Control-Allow-Origin" => "*"
        }
      end

      def body
        data = {
          error:   status,
          message: error.message
        }

        JSON.dump(data)
      end
    end
  end
end
