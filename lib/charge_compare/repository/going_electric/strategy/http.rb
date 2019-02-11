require "charge_compare/model/station"

module ChargeCompare
  module Repository
    module GoingElectric
      module Strategy
        class Http   

          REGION_MAPPING = {
            "Österreich" => "at",
            "Deutschland" => "de",
            "Italien" => "it",
            "Niederlande" => "nl",
            "Schweiz" => "ch",
            "Slowenien" => "sl",
            "Kroatien" => "hr"
          }
          
          def find_station(id:)
            to_model(request(id))
          end

          def request(station_id)
            connection = Faraday.new("https://api.goingelectric.de")

            data = {
              ge_id: station_id,
              key: ChargeCompareService.configuration.going_electric_api_key
            }

            response = connection.post("/chargepoints") do |req|
              req.body = URI.encode_www_form(data)
            end
        
            JSON.parse(response.body,symbolize_names: true)
          end

          def to_model(hash)
            st = hash[:chargelocations].first
            Model::Station.new(
              id: st[:ge_id].to_s,
              name: st[:name],
              longitude: st[:coordinates][:lng],
              latitude: st[:coordinates][:lat],
              is_free_charging: st[:cost][:freecharging],
              is_free_parking: st[:cost][:freeparking],
              region: REGION_MAPPING[st[:address][:country]],
              charge_card_ids: st[:chargecards].map{ |cc| cc[:id].to_s},
              connectors: st[:chargepoints].map { |cp| parse_connector(cp) },
              going_electric_url: "https:"+st[:url]
            )
          end

          def parse_connector(hash)
            {
              speed: hash[:power],
              plug: hash[:type],
              count: hash[:count]
            }
          end
        end
      end
    end
  end
end