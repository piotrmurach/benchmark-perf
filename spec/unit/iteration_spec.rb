# encoding: utf-8

RSpec.describe Benchmark::Perf::Iteration do
  it "defines cycles per 100 microseconds" do
    bench = described_class.new
    sample = bench.run_warmup { 'x' * 1_000_000 }
    expect(sample).to be > 25
  end

  it "measures 10K iterations per second" do
    bench = described_class.new
    sample = bench.run { 'x' * 1_000_000 }
    expect(sample.size).to eq(4)
    expect(sample[0]).to be > 250
    expect(sample[1]).to be > 5
    expect(sample[2]).to be > 250
  end
end
