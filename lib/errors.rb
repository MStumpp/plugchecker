# frozen_string_literal: true

module Errors
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class RequestInvalid < StandardError; end
  class ServiceUnavailable < StandardError; end
end
