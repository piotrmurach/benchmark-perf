# encoding: utf-8

RSpec.describe Benchmark::Perf::ExecutionTime do
  it "provides linear range" do
    bench = described_class.new
    expect(bench.linear_range(0, 3)).to eq([0,1,2,3])
  end

  it "provides default benchmark range" do
    bench = described_class.new
    expect(bench.bench_range.size).to eq(30)
  end

  it "provides measurements for 30 samples by default" do
    bench = described_class.new
    sample = bench.run { 'x' * 1024 }
    expect(sample).to all(be < 0.01)
  end

  it "doesn't benchmark raised exception" do
    bench = described_class.new
    expect {
      bench.run { raise 'boo' }
    }.to raise_error(StandardError)
  end

  it "fails to load marshalled data" do
    bench = described_class.new
    #allow(::Marshal).to receive(:load).and_raise('boo')
    fake = Class.new do
      def load
        raise 'boo'
      end
    end
    stub_const("::Marshal", fake)
    expect {
      bench.run { 'x' * 1024 }
    }.to raise_error(Benchmark::Perf::MarshalError)
  end

  it "measures complex object" do
    bench = described_class.new
    sample = bench.run { {foo: Object.new, bar: :piotr} }
    expect(sample).to all(be < 0.001)
  end

  it "executes code to warmup ruby vm" do
    bench = described_class.new
    sample = bench.run_warmup { 'x' * 1_000_000 }
    expect(sample).to eq(1)
  end

  it "measures work performance for 10 samples" do
    bench = described_class.new
    sample = bench.run(10) { 'x' * 1_000_000 }
    expect(sample.size).to eq(2)
    expect(sample).to all(be < 0.01)
  end
end
