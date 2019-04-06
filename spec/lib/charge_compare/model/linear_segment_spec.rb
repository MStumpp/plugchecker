# frozen_string_literal: true

require "charge_compare/model/linear_segment"

describe ChargeCompare::Model::LinearSegment do
  describe "#calculate_price" do
    subject { model.calculate_price(options) }

    shared_examples "a price of" do |price|
      it { expect(subject).to eq price }
    end

    context "no range" do
      context "kwh" do
        let(:model) { FactoryBot.build(:linear_segment, dimension: "kwh", price: 1) }
        let(:options) { OpenStruct.new(energy: 10) }

        it_behaves_like "a price of", 10
      end

      context "minute" do
        let(:model) { FactoryBot.build(:linear_segment, dimension: "minute", price: 1) }
        let(:options) { OpenStruct.new(duration: 10) }

        it_behaves_like "a price of", 10
      end
    end

    context "range" do
      let(:model) do
        FactoryBot.build(:linear_segment,
                         dimension: "minute",
                         price:     1,
                         range_gte: lower_bound,
                         range_lt:  upper_bound)
      end
      let(:lower_bound) { 10 }
      let(:upper_bound) { 25 }
      let(:options) { OpenStruct.new(duration: 40) }

      it_behaves_like "a price of", 15

      context "no upper bound" do
        let(:upper_bound) { nil }

        it_behaves_like "a price of", 30
      end

      context "no lower bound" do
        let(:lower_bound) { nil }

        it_behaves_like "a price of", 25
      end
    end
  end
end
