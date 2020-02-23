# frozen_string_literal: true

RSpec.describe Benchmark::Perf::Stats do
  context "#average" do
    it "calculates average without measurements" do
      expect(described_class.average([])).to eq(0)
    end

    it "calculates average with measurements" do
      expect(described_class.average([1,2,3])).to eq(2.0)
    end
  end

  context "#variance" do
    it "calculates variance of no measurements" do
      expect(described_class.variance([])).to eq(0)
    end

    it "calculates variance of measurements" do
      expect(described_class.variance([1,2,3])).to eq(2.to_f/3)
    end
  end

  context "#stdev" do
    it "calculates standard deviation of no measurements" do
      expect(described_class.stdev([])).to eq(0)
    end

    it "calculates standard deviation of measurements" do
      expect(described_class.stdev([1,2,3])).to eq(Math.sqrt(2.to_f/3))
    end
  end
end
