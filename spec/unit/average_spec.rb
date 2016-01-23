# encoding: utf-8

RSpec.describe Benchmark::Perf do
  it "calculates average without measurements" do
    expect(Benchmark::Perf.average([])).to eq(0)
  end

  it "calculates average with measurements" do
    expect(described_class.average([1,2,3])).to eq(2.0)
  end
end
