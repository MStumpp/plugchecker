# frozen_string_literal: true

require "charge_compare/model/connector_speed_restriction"
require "spec/lib/charge_compare/model/shared"

describe ChargeCompare::Model::ConnectorSpeedRestriction do
  describe "#fulfilled?" do
    subject { model.fulfilled?(double(speed: speed), double, double) }

    let(:model) { FactoryBot.build(:connector_speed_restriction, **values) }

    context "allowance allow" do
      it_behaves_like "fulfilled" do
        let(:values) { { value: [10, 20] } }
        let(:speed) { 10 }
      end

      it_behaves_like "unfulfilled" do
        let(:values) { { value: [10, 20] } }
        let(:speed) { 30 }
      end
    end

    context "allowance deny" do
      it_behaves_like "fulfilled" do
        let(:values) { { value: [10, 20], allowance: "deny" } }
        let(:speed) { 30 }
      end

      it_behaves_like "unfulfilled" do
        let(:values) { { value: [10, 20], allowance: "deny" } }
        let(:speed) { 10 }
      end
    end

    context "value is range" do
      it_behaves_like "fulfilled" do
        let(:values) { { value: [10, 20], value_is_range: true } }
        let(:speed) { 15 }
      end

      it_behaves_like "unfulfilled" do
        let(:values) { { value: [10, 20], value_is_range: true } }
        let(:speed) { 25 }
      end

      it_behaves_like "fulfilled" do
        let(:values) { { value: [nil, 20], value_is_range: true } }
        let(:speed) { 15 }
      end

      it_behaves_like "fulfilled" do
        let(:values) { { value: [10, nil], value_is_range: true } }
        let(:speed) { 15 }
      end

      context "invalid number of values" do
        let(:values) { { value: [10, 20, 40], value_is_range: true } }
        let(:speed) { 25 }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context "invalid values" do
        let(:values) { { value: [40, 20], value_is_range: true } }
        let(:speed) { 25 }

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end
end
