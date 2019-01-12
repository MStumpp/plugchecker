
class StaticChargePlan

  attr_reader :station_details

  def initialize(station_details:, key: nil)
    @station_details = station_details
  end

  def run
    []
  end
end