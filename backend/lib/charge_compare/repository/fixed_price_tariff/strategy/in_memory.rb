require "charge_compare/model/fixed_price_tariff"

module ChargeCompare
  module Repository
    module FixedPriceTariff
      module Strategy
        class InMemory

          PROVIDER_CONFIG_LOCATION = "config/providers"

          def where(station:)
            station.charge_card_ids.map { |ccid| store[ccid] }.flatten.compact.uniq
          end

          def load
            Dir[File.join(PROVIDER_CONFIG_LOCATION,"*.yml")].each do |file_path|
              hash = YAML.load_file(file_path)
              hash["tariffs"].each { |tariff| store_tariff(tariff, hash) }
            end
          end

          def store_tariff(tariff, root)
            model = Model::FixedPriceTariff.new(
              name: tariff["name"],
              charge_card_id: tariff["charge_card_id"].to_s,
              provider: root["provider"],
              valid_to: time_or_nil(tariff["valid_to"]),
              valid_from: time_or_nil(tariff["valid_to"]),
              prices: tariff["prices"].map { |tp| load_tariff_price(tp) }
            )

            store[model.charge_card_id] ||= []
            store[model.charge_card_id] << model
          end

          def load_tariff_price(tariff_price)
            Model::TariffPrice.new(
              restrictions: tariff_price.fetch("restrictions",[]).map { |res| load_restriction(res) },
              decomposition: tariff_price.fetch("decomposition").map { |seg| load_segment(seg) }
            )
          end

          def load_restriction(hash)
            case hash["type"]
              when "region"
                Model::RegionRestriction.new(allowed_value: hash["value"])
              when "connector_speed"
                Model::ConnectorSpeedRestriction.new(allowed_value: hash["value"])
              when "connector_type"
                Model::ConnectorTypeRestriction.new(allowed_value: hash["value"])
              when "provider_customer_restriction"
                Model::ProviderCustomerRestriction.new
            end
          end

          def load_segment(hash)
            case hash["type"]
              when "constant"
                Model::ConstantSegment.new(price: hash["price"])
              when "linear"
                range = hash.fetch("range",[])
                Model::LinearSegment.new(
                  price: hash["price"], 
                  range_gte: range.first, 
                  range_lt: range.last, 
                  dimension: hash["dimension"])
            end
          end

          def time_or_nil(value)
            return unless value
            Time.at(value.to_i / 1000)
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
          
          private def store
            self.class.store
          end
        end
      end
    end
  end
end