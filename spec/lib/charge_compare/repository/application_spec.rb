# frozen_string_literal: true

require "charge_compare/repository/application"

describe ChargeCompare::Repository::Application do
  before { ChargeCompare::Repository::Application.clear }

  describe "::load" do
    subject { described_class.load }

    let(:model) { FactoryBot.build(:application) }

    let(:values) do
      [%w[Key Name ReadCosts ReadTariffs WriteTariffs],
       [model.api_key, model.name,
        model.read_costs.to_s.upcase,
        model.read_tariffs.to_s.upcase,
        model.write_tariffs.to_s.upcase]]
    end

    before do
      service_double = instance_double("Google::Apis::SheetsV4::SheetsService")
      allow(Google::Apis::SheetsV4::SheetsService)
        .to receive(:new) { service_double }

      allow(::Google::Auth::ServiceAccountCredentials)
        .to receive(:make_creds)
        .with(scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY)

      allow(service_double).to receive(:authorization=)

      allow(service_double)
        .to receive(:get_spreadsheet_values)
        .with(ChargeCompareService.configuration.application_sheet_id, "Applications")
        .and_return(double(values: values))
    end

    it "loads the applications from google drive" do
      subject

      expect(described_class.find(api_key: model.api_key)).to eq model
    end

    it "can't load the applications" do
      allow(Google::Apis::SheetsV4::SheetsService)
        .to receive(:new)
        .and_raise

      expect { subject }.to raise_error(Errors::ServiceUnavailable)
    end
  end

  describe ":find" do
    subject { described_class.find(api_key: api_key) }

    context "existing" do
      let(:model) { FactoryBot.create(:application) }
      let(:api_key) { model.api_key }

      it "finds the application" do
        expect(subject).to eq model
      end
    end

    context "non-existing" do
      let(:api_key) { SecureRandom.uuid }

      it "raises an error" do
        expect { subject }.to raise_error(Errors::NotFound)
      end
    end
  end
end
