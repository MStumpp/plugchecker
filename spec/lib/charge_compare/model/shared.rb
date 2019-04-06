# frozen_string_literal: true

shared_examples "fulfilled" do
  it { expect(subject).to eq true }
end

shared_examples "unfulfilled" do
  it { expect(subject).to eq false }
end
