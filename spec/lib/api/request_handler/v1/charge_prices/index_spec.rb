# frozen_string_literal: true

require "api/request_handler/v1/charge_prices/index"

describe Api::RequestHandler::V1::ChargePrices::Index do
  subject { described_class.new(request: request).to_dto }

  let(:request) do
    instance_double("Rack::Request", body: StringIO.new(body.to_json), env: { "HTTP_API_KEY" => some_string })
  end

  let(:some_float) { 12.34 }
  let(:some_int) { 30 }
  let(:some_bool) { true }
  let(:country) { "at" }
  let(:some_string) { "something" }
  let(:energy) { "dc" }
  let(:currency) { "eur" }
  let(:car_ac_phases) { 1 }
  let(:type) { "charge_price_request" }
  let(:data_adapter) { "going_electric" }

  let(:body) do
    {
      data: {
        type:       type,
        attributes: {
          data_adapter:    data_adapter,
          station:         {
            longitude:     some_float,
            latitude:      some_float,
            country:       country,
            network:       some_string,
            charge_points: [
              {
                power: some_float,
                plug:  some_string
              }
            ]
          },
          options:         {
            energy:                    some_float,
            duration:                  some_int,
            car_ac_phases:             car_ac_phases,
            provider_customer_tariffs: some_bool,
            currency:                  currency
          },
          charge_card_ids: [
            some_string
          ]
        }
      }
    }
  end

  it "parses the request" do
    body = subject.body

    expect(body.station.latitude).to eq some_float
    expect(body.station.longitude).to eq some_float
    expect(body.station.region).to eq country
    expect(body.station.network).to eq some_string
    expect(body.station.connectors).to eq [OpenStruct.new(speed: some_float, plug: some_string)]
    expect(body.options.energy).to eq some_float
    expect(body.options.duration).to eq some_int
    expect(body.options.car_ac_phases).to eq car_ac_phases
    expect(body.options.provider_customer_tariffs).to eq some_bool
    expect(body.options.currency).to eq currency
    expect(body.charge_card_ids).to eq [some_string]
  end

  it "parses the headers" do
    expect(subject.headers[:api_key]).to eq some_string
  end

  context "errors" do
    shared_examples "an error" do
      it { expect { subject }.to raise_error(Errors::RequestInvalid) }
    end

    context "invalid type" do
      let(:type) { "request" }
      it_behaves_like "an error"
    end

    context "invalid data adapter" do
      let(:type) { "default" }
      it_behaves_like "an error"
    end

    context "invalid float" do
      let(:some_float) { "12.34" }
      it_behaves_like "an error"
    end

    context "invalid bool" do
      let(:some_bool) { "invalid" }
      it_behaves_like "an error"
    end

    context "invalid string" do
      let(:some_string) { 1 }
      it_behaves_like "an error"
    end

    context "invalid car_ac_phases" do
      let(:car_ac_phases) { 2 }
      it_behaves_like "an error"
    end

    context "invalid currency" do
      let(:currency) { "ab" }
      it_behaves_like "an error"
    end

    context "invalid charge_points array" do
      before { body[:data][:attributes][:station][:charge_points] = "test" }
      it_behaves_like "an error"
    end

    context "invalid charge card id array" do
      before { body[:data][:attributes][:charge_card_ids] = "test" }
      it_behaves_like "an error"
    end
  end
end
