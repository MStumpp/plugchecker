# frozen_string_literal: true

require "charge_compare/model/network_restriction"
require "spec/lib/charge_compare/model/shared"

describe ChargeCompare::Model::NetworkRestriction do
  describe "#fulfilled?" do
    subject { model.fulfilled?(double, double(network: network), double) }

    let(:model) { FactoryBot.build(:network_restriction, **values) }

    context "allowance allow" do
      let(:values) { { value: ["Test"], allowance: "allow" } }

      it_behaves_like "fulfilled" do
        let(:network) { "Test" }
      end

      it_behaves_like "unfulfilled" do
        let(:network) { "Invalid" }
      end
    end

    context "allowance deny" do
      let(:values) { { value: ["Test"], allowance: "deny" } }

      it_behaves_like "fulfilled" do
        let(:network) { "Invalid" }
      end

      it_behaves_like "unfulfilled" do
        let(:network) { "Test" }
      end
    end
  end
end
