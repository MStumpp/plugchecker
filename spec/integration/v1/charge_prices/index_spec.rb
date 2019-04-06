# frozen_string_literal: true

require "app"

describe App do
  include Rack::Test::Methods

  def app
    App
  end

  let(:body) do
    {
      data: {
        type:       "charge_price_request",
        attributes: {
          data_adapter:    "going_electric",
          station:         {
            longitude:     14.13117,
            latitude:      48.289453,
            country:       "Österreich",
            network:       "Wien Energie",
            charge_points: [
              {
                power: 22,
                plug:  "CCS"
              }
            ]
          },
          options:         {
            energy:   30,
            duration: 30
          },
          charge_card_ids: [
            "274"
          ]
        }
      }
    }
  end

  let(:api_key) { SecureRandom.uuid }

  before do
    FactoryBot.create(:application, api_key: api_key)
  end

  it "request the charge prices" do
    post "/v1/charge_prices", MultiJson.dump(body), "HTTP_API_KEY" => api_key

    expect(last_response.status).to be 200

    verify(format: :json) { last_response.body }
  end
end
