# frozen_string_literal: true

require "charge_compare/use_case/concerns/authorization"

describe ChargeCompare::UseCase::Concerns::Authorization do
  class TestAuthClass
    include ChargeCompare::UseCase::Concerns::Authorization

    def initialize(dto)
      @dto = dto
    end

    attr_reader :dto
  end

  subject { TestAuthClass.new(dto) }

  context "valid api key with rights present" do
    let(:model) { FactoryBot.build(:application, read_costs: true, read_tariffs: false) }
    let(:dto) { OpenStruct.new(headers: { api_key: model.api_key }) }

    before do
      allow(ChargeCompare::Repository::Application)
        .to receive(:find)
        .with(api_key: model.api_key)
        .and_return(model)
    end

    it "authorizes the app" do
      expect { subject.authorize_app!(:read_costs) }.not_to raise_error(Errors::Forbidden)
    end

    it "doesn't authorize the app" do
      expect { subject.authorize_app!(:read_tariffs) }.to raise_error(Errors::Forbidden)
    end
  end

  context "api key missing" do
    let(:dto) { OpenStruct.new(headers: {}) }

    it "doesn't authorize the app" do
      expect { subject.authorize_app!(:read_tariffs) }.to raise_error(Errors::Forbidden)
    end
  end

  context "api key invalid" do
    let(:api_key) { SecureRandom.uuid }
    let(:dto) { OpenStruct.new(headers: { api_key: api_key }) }

    before do
      allow(ChargeCompare::Repository::Application)
        .to receive(:find)
        .with(api_key: api_key)
        .and_raise(Errors::NotFound)
    end

    it "doesn't authorize the app" do
      expect { subject.authorize_app!(:read_tariffs) }.to raise_error(Errors::Forbidden)
    end
  end
end
