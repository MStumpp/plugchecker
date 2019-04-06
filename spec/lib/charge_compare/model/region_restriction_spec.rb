# frozen_string_literal: true

require "charge_compare/model/region_restriction"
require "spec/lib/charge_compare/model/shared"

describe ChargeCompare::Model::RegionRestriction do
  describe "#fulfilled?" do
    subject { model.fulfilled?(double, double(region: region), double) }

    let(:model) { FactoryBot.build(:region_restriction, **values) }

    context "allowance allow" do
      let(:values) { { value: ["at"], allowance: "allow" } }

      it_behaves_like "fulfilled" do
        let(:region) { "at" }
      end

      it_behaves_like "unfulfilled" do
        let(:region) { "de" }
      end
    end

    context "allowance deny" do
      let(:values) { { value: ["at"], allowance: "deny" } }

      it_behaves_like "fulfilled" do
        let(:region) { "de" }
      end

      it_behaves_like "unfulfilled" do
        let(:region) { "at" }
      end
    end
  end
end
