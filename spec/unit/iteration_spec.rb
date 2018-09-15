# frozen_string_literal: true

RSpec.describe Benchmark::Perf::Iteration do
  it "defines cycles per 100 microseconds" do
    sample = described_class.run_warmup { 'x' * 1_000_000 }
    expect(sample).to be > 25
  end

  it "measures 10K iterations per second" do
    sample = described_class.run { 'x' * 1_000_000 }

    expect(sample.size).to eq(4)
    expect(sample[0]).to be > 250
    expect(sample[1]).to be > 5
    expect(sample[2]).to be > 250
  end

  it "does't measure broken code" do
    expect {
      described_class.run { raise 'boo' }
    }.to raise_error(StandardError, /boo/)
  end
end
