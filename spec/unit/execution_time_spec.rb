# frozen_string_literal: true

RSpec.describe Benchmark::Perf::ExecutionTime do
  it "provides linear range" do
    expect(described_class.linear_range(0, 3)).to eq([0,1,2,3])
  end

  it "provides default benchmark range" do
    allow(described_class).to receive(:run_in_subprocess).and_return(0.1)
    described_class.run { 'x' * 1024 }
    expect(described_class).to have_received(:run_in_subprocess).exactly(30).times
  end

  it "accepts custom number of samples" do
    allow(described_class).to receive(:run_in_subprocess).and_return(0.1)
    described_class.run(times: 12) { 'x' * 1024 }
    expect(described_class).to have_received(:run_in_subprocess).exactly(12).times
  end

  it "provides measurements for 30 samples by default" do
    sample = described_class.run { 'x' * 1024 }
    expect(sample).to all(be < 0.01)
  end

  it "doesn't benchmark raised exception" do
    expect {
      described_class.run { raise 'boo' }
    }.to raise_error(StandardError)
  end

  it "measures complex object" do
    sample = described_class.run { {foo: Object.new, bar: :piotr} }
    expect(sample).to all(be < 0.01)
  end

  it "executes code to warmup ruby vm" do
    sample = described_class.run_warmup { 'x' * 1_000_000 }
    expect(sample).to eq(1)
  end

  it "measures work performance for 10 samples" do
    sample = described_class.run(times: 10) { 'x' * 1_000_000 }
    expect(sample.size).to eq(2)
    expect(sample).to all(be < 0.01)
  end
end
