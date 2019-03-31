# frozen_string_literal: true

require "charge_compare/model/application"
require "google/apis/sheets_v4"
require "googleauth"
require "errors"

module ChargeCompare
  module Repository
    module Application
      module Strategy
        class InMemory
          def find(api_key:)
            store.fetch(api_key) { raise Errors::NotFound.new("No application with key #{api_key}") }
          end

          def load
            response = google_service.get_spreadsheet_values(sheet_id, "Applications")

            clear
            response.values.drop(1).each do |row|
              model = to_model(row)
              store[model.api_key] = model
            end
          rescue StandardError => e
            raise Errors::ServiceUnavailable.new(e)
          end

          def google_service
            service = Google::Apis::SheetsV4::SheetsService.new
            auth = ::Google::Auth::ServiceAccountCredentials
                   .make_creds(scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY)
            service.authorization = auth
            service
          end

          def sheet_id
            ChargeCompareService.configuration.application_sheet_id
          end

          def to_model(row)
            Model::Application.new(
              api_key:       row[0],
              name:          row[1],
              read_costs:    to_bool(row[2]),
              read_tariffs:  to_bool(row[3]),
              write_tariffs: to_bool(row[4])
            )
          end

          def to_bool(val)
            val == "TRUE"
          end

          class << self
            def store
              @store || clear
            end

            def clear
              @store = {}
            end
          end

          def clear
            self.class.clear
          end

          private

          def store
            self.class.store
          end
        end
      end
    end
  end
end
