# frozen_string_literal: true

require "charge_compare/model/constant_segment"

describe ChargeCompare::Model::ConstantSegment do
  describe "#calculate_price" do
    subject { model.calculate_price(double) }

    let(:model) { FactoryBot.build(:constant_segment, price: 1) }
    it { expect(subject).to eq model.price }
  end
end
