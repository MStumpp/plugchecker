require_relative "./fetch_station_details"
require_relative "./plugsurfing"
require_relative "./static_charge_plan"

class ComparePricesOfStation

  attr_reader :station_id

  def initialize(station_id:)
    @station_id = station_id 
  end

  MAPPING = {
    7 => {
      adapter: Plugsurfing
    },
    8 => {
      adapter: Plugsurfing
    },
    274 => {
      adapter: StaticChargePlan,
      key: "maingau"
    }
  }

  def run
    station_details = fetch_station_details
    collect_prices(station_details)
  end

  def fetch_station_details
    FetchStationDetails.new(station_id: station_id).run
  end

  def collect_prices(station_details)
    prices_for_cards = station_details[:chargecards].map do |cc|
      card = MAPPING[cc[:id]]
      next unless card
      cc[:prices] = card[:adapter].new(station_details: station_details, key: card[:key]).run
      cc
    end

    prices_for_cards.compact
  end


end