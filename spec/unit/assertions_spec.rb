# frozen_string_literal

RSpec.describe Benchmark::Perf, 'assertions' do
  it "passes asertion by performing under threshold" do
    bench = Benchmark::Perf
    assertion = bench.assert_perform_under(0.01, repeat: 2) { 'x' * 1_024 }
    expect(assertion).to eq(true)
  end

  it "passes asertion by performing 10K ips" do
    bench = Benchmark::Perf
    assertion = bench.assert_perform_ips(10_000, warmup: 1.3) { 'x' * 1_024 }
    expect(assertion).to eq(true)
  end
end
