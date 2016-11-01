# encoding: utf-8

RSpec.describe Benchmark::Perf, 'arithmetic' do
  context '#average' do
    it "calculates average without measurements" do
      expect(Benchmark::Perf.average([])).to eq(0)
    end

    it "calculates average with measurements" do
      expect(Benchmark::Perf.average([1,2,3])).to eq(2.0)
    end
  end

  context '#variance' do
    it "calculates variance of no measurements" do
      expect(Benchmark::Perf.variance([])).to eq(0)
    end

    it "calculates variance of measurements" do
      expect(Benchmark::Perf.variance([1,2,3])).to eq(2.to_f/3)
    end
  end

  context '#std_dev' do
    it "calculates standard deviation of no measurements" do
      expect(Benchmark::Perf.std_dev([])).to eq(0)
    end

    it "calculates standard deviation of measurements" do
      expect(Benchmark::Perf.std_dev([1,2,3])).to eq(Math.sqrt(2.to_f/3))
    end
  end
end
