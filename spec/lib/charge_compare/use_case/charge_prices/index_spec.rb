# frozen_string_literal: true

require "charge_compare/use_case/charge_prices/index"

describe ChargeCompare::UseCase::ChargePrices::Index do
  describe "#run" do
    let(:instance) { described_class.new(dto) }
    subject { instance.run }

    before do
      allow(instance)
        .to receive(:authorize_app!)
        .and_return(true)

      allow(ChargeCompare::UseCase::Tariffs::Show)
        .to receive(:new)
        .with(request: OpenStruct.new(body: station_with_charge_card_ids))
        .and_return(double(run: double(available_tariffs: available_tariffs)))

      allow(ChargeCompare::UseCase::ChargePrices::CalculatePriceForTariff)
        .to receive(:new)
        .with(station: station, tariff: tariff, options: options_with_connector_idx)
        .and_return(double(run: price))
    end

    let(:dto) do
      double(
        body: double(
          station:         station,
          charge_card_ids: charge_card_ids,
          options:         options
        )
      )
    end

    let(:station) do
      OpenStruct.new(connectors: [OpenStruct.new(speed: 22, plug: "CCS")], region: "Deutschland")
    end

    let(:station_with_charge_card_ids) do
      OpenStruct.new(
        connectors:      [OpenStruct.new(speed: 22, plug: "CCS", energy: "dc")],
        region:          "de",
        charge_card_ids: charge_card_ids
      )
    end

    let(:charge_card_ids) { ["123"] }

    let(:options) do
      OpenStruct.new
    end

    let(:options_with_connector_idx) do
      OpenStruct.new(connector_index: 0)
    end

    let(:available_tariffs) do
      [tariff]
    end

    let(:price) { 2.5 }

    let(:tariff) do
      FactoryBot.build(:fixed_price_tariff, name: "Standard")
    end

    let(:charge_price) do
      FactoryBot.build(:charge_price, connector_prices: [{ energy: "dc", plug: "CCS", speed: 22, price: 2.5 }])
    end

    it "has tariffs" do
      expect(subject.charge_prices).to eq [charge_price]
    end

    context "no charge price available" do
      let(:price) { nil }

      it "has no tariffs" do
        expect(subject.charge_prices).to eq []
      end
    end
  end
end
