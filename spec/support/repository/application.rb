# frozen_string_literal: true

module ChargeCompare
  module Repository
    module Application
      delegate_to_strategy :create
      delegate_to_strategy :clear

      module Strategy
        class InMemory
          def create(application:)
            store[application.api_key] = application
          end
        end
      end
    end
  end
end
