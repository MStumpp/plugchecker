# frozen_string_literal: true

require "charge_compare/model/connector_energy_restriction"
require "spec/lib/charge_compare/model/shared"

describe ChargeCompare::Model::ConnectorEnergyRestriction do
  describe "#fulfilled?" do
    subject { model.fulfilled?(double(energy: energy), double, double) }

    let(:model) { FactoryBot.build(:connector_energy_restriction, **values) }

    context "allowance allow" do
      let(:values) { { value: "ac", allowance: "allow" } }

      it_behaves_like "fulfilled" do
        let(:energy) { "ac" }
      end

      it_behaves_like "unfulfilled" do
        let(:energy) { "dc" }
      end
    end

    context "allowance deny" do
      let(:values) { { value: "ac", allowance: "deny" } }

      it_behaves_like "fulfilled" do
        let(:energy) { "dc" }
      end

      it_behaves_like "unfulfilled" do
        let(:energy) { "ac" }
      end
    end
  end
end
