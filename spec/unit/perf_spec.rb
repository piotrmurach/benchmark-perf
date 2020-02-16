# frozen_string_literal: true

RSpec.describe Benchmark::Perf do
  it "provides execution time performance information" do
    result = Benchmark::Perf.cpu { "foo" + "bar" }

    expect(result).to contain_exactly(
      a_kind_of(Float),
      a_kind_of(Float)
    )
  end

  it "provides iterations per second performance information" do
    result = Benchmark::Perf.ips(warmup: 0.01, time: 0.02) do
      "foo" + "bar"
    end

    expect(result).to contain_exactly(
      a_kind_of(Integer),
      a_kind_of(Integer),
      a_kind_of(Integer),
      a_kind_of(Float),
    )
  end
end
