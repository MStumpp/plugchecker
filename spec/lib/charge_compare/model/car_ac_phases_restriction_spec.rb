# frozen_string_literal: true

require "charge_compare/model/car_ac_phases_restriction"
require "spec/lib/charge_compare/model/shared"

describe ChargeCompare::Model::CarACPhasesRestriction do
  describe "#fulfilled?" do
    subject { model.fulfilled?(double, double, double(car_ac_phases: car_ac_phases)) }

    let(:model) { FactoryBot.build(:car_ac_phases_restriction, **values) }

    context "allowance allow" do
      let(:values) { { value: 3, allowance: "allow" } }

      it_behaves_like "fulfilled" do
        let(:car_ac_phases) { 3 }
      end

      it_behaves_like "unfulfilled" do
        let(:car_ac_phases) { 1 }
      end
    end

    context "allowance deny" do
      let(:values) { { value: 3, allowance: "deny" } }

      it_behaves_like "fulfilled" do
        let(:car_ac_phases) { 1 }
      end

      it_behaves_like "unfulfilled" do
        let(:car_ac_phases) { 3 }
      end
    end
  end
end
