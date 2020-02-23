# frozen_string_literal: true

RSpec.describe Benchmark::Perf::Iteration do
  it "defines cycles per 100 microseconds" do
    sample = described_class.run_warmup(warmup: 0.1) { "x" * 1_000_000 }
    expect(sample).to be > 25
  end

  it "measures 10K iterations per second" do
    sample = described_class.run(warmup: 0.1, time: 0.2) { "x" * 1_000_000 }

    expect(sample.to_a.size).to eq(4)
    expect(sample.avg).to be > 150
    expect(sample.stdev).to be > 5
    expect(sample.iter).to be > 150
  end

  it "does't measure broken code" do
    expect {
      described_class.run { raise "boo" }
    }.to raise_error(StandardError, /boo/)
  end

  it "runs bnechmark correctly for time less than warmup" do
    sample = described_class.run(time: 0.1, warmup: 0.2) { "foo" + "bar" }

    expect(sample.avg).to be > 0
    expect(sample.stdev).to be > 0
    expect(sample.iter).to be > 0
    expect(sample.dt).to be >= 0.1
  end
end
