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
        type:       "tariff_options",
        attributes: {
          longitude:       14.13117,
          latitude:        48.289453,
          region:          "at",
          network:         "Wien Energie",
          connectors:      [
            {
              speed:  22,
              energy: "ac"
            }
          ],
          charge_card_ids: [
            "274"
          ]
        }
      }
    }
  end

  it "request the tariffs" do
    post "/v1/tariffs", MultiJson.dump(body)

    expect(last_response.status).to be 200

    verify(format: :json) { last_response.body }
  end
end
