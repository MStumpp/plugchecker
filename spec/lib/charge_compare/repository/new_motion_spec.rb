# frozen_string_literal: true

require "charge_compare/repository/new_motion"

describe ChargeCompare::Repository::NewMotion do
  describe "#where" do
    subject { described_class.where(station: station) }

    around { |example| Timecop.freeze { example.run } }

    let(:station) do
      build(:station, longitude: 14.13117, latitude: 48.289453)
    end

    let(:expected_result) do
      build(:flexible_price_tariff,
            provider: "New Motion",
            url:      "https://my.newmotion.com/",
            valid_at: Time.now.utc,
            prices:   [
              {
                restrictions:  [build(:connector_speed_restriction, value: [11])],
                decomposition: [build(:linear_segment, price: 0.16, dimension: "minute")]
              },
              {
                restrictions:  [build(:connector_speed_restriction, value: [3.7])],
                decomposition: [build(:constant_segment, price: 12.0)]
              }
            ])
    end

    let(:around_response) { File.read("spec/fixtures/webmock/new_motion/around.json") }
    let(:around_status) { 200 }

    let(:show_response) { File.read("spec/fixtures/webmock/new_motion/show.json") }
    let(:show_status) { 200 }

    before do
      lng1 = station.longitude - 0.1
      lng2 = station.longitude + 0.1
      lat1 = station.latitude - 0.1
      lat2 = station.latitude + 0.1
      stub_request(:get, "https://my.newmotion.com/api/map/v2/markers/#{lng1}/#{lng2}/#{lat1}/#{lat2}")
        .to_return(status: around_status, body: around_response)

      stub_request(:get, "https://my.newmotion.com/api/map/v2/locations/2599919")
        .to_return(status: show_status, body: show_response)
    end

    it "gets the expected tariff" do
      expect(subject).to eq [expected_result]
    end

    # TODO: Add test for nearby use case

    context "service unavailable" do
      let(:around_status) { 400 }

      it "gets an empty result" do
        expect(subject).to eq []
      end
    end

    context "faraday error" do
      before do
        allow(Faraday)
          .to receive(:new)
          .and_raise(Faraday::Error)
      end

      it "gets an empty result" do
        expect(subject).to eq []
      end
    end
  end
end
