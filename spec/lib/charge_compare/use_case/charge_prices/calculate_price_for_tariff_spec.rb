# frozen_string_literal: true

require "charge_compare/use_case/charge_prices/calculate_price_for_tariff"

describe ChargeCompare::UseCase::ChargePrices::CalculatePriceForTariff do
  describe "#run" do
    subject { described_class.new(station: station, tariff: tariff, options: options).run }

    let(:station) { double(network: "Kelag", region: "at", connectors: [double(speed: 22, energy: "ac")]) }
    let(:options) do
      double(
        duration:                  30,
        kwh:                       "20",
        car_ac_phases:             3,
        provider_customer_tariffs: provider_customer_tariffs,
        connector_index:           0
      )
    end
    let(:tariff) do
      FactoryBot.build(:fixed_price_tariff,
                       prices: [
                         {
                           restrictions:  [build(:region_restriction, value: ["at"])],
                           decomposition: [build(:constant_segment, price: 1)]
                         }
                       ])
    end

    let(:provider_customer_tariffs) { false }

    shared_examples "gets a price" do
      it { expect(subject).to eq 1 }
    end

    shared_examples "doesn't get a price" do
      it { expect(subject).to eq nil }
    end

    it_behaves_like "gets a price"

    context "provider_customer_restriction unfulfilled" do
      let(:provider_customer_tariffs) { false }
      let(:tariff) { super().new(provider_customer_only: true) }

      it_behaves_like "doesn't get a price"
    end

    context "provider_customer_restriction fulfilled" do
      let(:provider_customer_tariffs) { true }
      let(:tariff) { super().new(provider_customer_only: true) }

      it_behaves_like "gets a price"
    end

    context "no components match" do
      let(:tariff) { FactoryBot.build(:fixed_price_tariff, prices: []) }

      it_behaves_like "doesn't get a price"
    end
  end
end
