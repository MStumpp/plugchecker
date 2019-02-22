# frozen_string_literal: true

require "charge_compare/repository/plugsurfing"

describe ChargeCompare::Repository::Plugsurfing do
  describe "#where" do
    subject { described_class.where(station: station) }

    around { |example| Timecop.freeze { example.run } }

    let(:station) do
      build(:station, longitude: 14.13117, latitude: 48.289453)
    end

    let(:expected_result) do
      build(:flexible_price_tariff,
            provider: "Plugsurfing",
            url:      "https://www.plugsurfing.com",
            valid_at: Time.now.utc,
            prices:   [
              {
                restrictions:  [build(:connector_speed_restriction, value: [11])],
                decomposition: [build(:linear_segment, price: 0.17416666666666666, dimension: "minute")]
              }
            ])
    end

    let(:around_response) { File.read("spec/fixtures/webmock/plugsurfing/around.json") }
    let(:around_status) { 200 }
    let(:around_body) do
      {
        "station-get-surface": {
          "min-lat":  station.latitude - 0.1, "max-lat":  station.latitude + 0.1,
          "min-long": station.longitude - 0.1, "max-long": station.longitude + 0.1
        }
      }
    end

    let(:show_response) { File.read("spec/fixtures/webmock/plugsurfing/show.json") }
    let(:show_status) { 200 }
    let(:show_body) do
      { "station-get-by-ids": { "station-ids": [137273] } }
    end

    before do
      stub_request(:post, "https://api.plugsurfing.com/api/v3/request")
        .with(body: JSON.dump(around_body))
        .to_return(status: around_status, body: around_response)

      stub_request(:post, "https://api.plugsurfing.com/api/v3/request")
        .with(body: JSON.dump(show_body))
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
