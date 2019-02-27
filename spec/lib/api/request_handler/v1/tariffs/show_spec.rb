# frozen_string_literal: true

require "api/request_handler/v1/tariffs/show"

describe Api::RequestHandler::V1::Tariffs::Show do
  subject { described_class.new(request: request).to_dto }

  let(:request) do
    instance_double("Rack::Request", body: StringIO.new(body.to_json))
  end

  let(:some_float) { 12.34 }
  let(:region) { "at" }
  let(:some_string) { "something" }
  let(:energy) { "dc" }

  let(:body) do
    {
      data: {
        type:       "tariff_options",
        attributes: {
          longitude:       some_float,
          latitude:        some_float,
          region:          region,
          network:         some_string,
          connectors:      [
            {
              speed:  some_float,
              energy: energy
            }
          ],
          charge_card_ids: [
            some_string
          ]
        }
      }
    }
  end

  it "parses the request" do
    body = subject.body

    expect(body.latitude).to eq some_float
    expect(body.longitude).to eq some_float
    expect(body.region).to eq region
    expect(body.network).to eq some_string
    expect(body.charge_card_ids).to eq [some_string]
    expect(body.connectors).to eq [OpenStruct.new(speed: some_float, energy: energy)]
  end

  context "errors" do
    shared_examples "an error" do
      it { expect { subject }.to raise_error(Errors::RequestInvalid) }
    end

    context "invalid float" do
      let(:some_float) { "12.34" }
      it_behaves_like "an error"
    end

    context "invalid region" do
      let(:region) { "test" }
      it_behaves_like "an error"
    end

    context "invalid string" do
      let(:some_string) { 1 }
      it_behaves_like "an error"
    end

    context "invalid energy" do
      let(:energy) { "ab" }
      it_behaves_like "an error"
    end

    context "invalid connector array" do
      before { body[:data][:attributes][:connectors] = "test" }
      it_behaves_like "an error"
    end

    context "invalid charge card id array" do
      before { body[:data][:attributes][:charge_card_ids] = "test" }
      it_behaves_like "an error"
    end
  end
end
