# frozen_string_literal: true

RSpec.describe Benchmark::Perf::IPSResult do
  it "defaults all calculations to zero" do
    result = described_class.new

    expect(result.avg).to eq(0)
    expect(result.stdev).to eq(0)
    expect(result.iter).to eq(0)
    expect(result.dt).to eq(0)
  end

  it "adds measurements correctly" do
    result = described_class.new

    result.add 1, 50_000
    result.add 2, 100_000
    result.add 0.5, 25_000

    expect(result.avg).to eq(50_000)
    expect(result.stdev).to eq(0)
    expect(result.iter).to eq(175_000)
    expect(result.dt).to eq(3.5)

    result.add 0.5, 25_000

    expect(result.avg).to eq(50_000)
    expect(result.stdev).to eq(0)
    expect(result.iter).to eq(200_000)
    expect(result.dt).to eq(4)
  end

  it "inpsects content" do
    result = described_class.new

    result.add 1, 50_000
    result.add 2, 100_000

    expect(result.inspect).to eq("#<Benchmark::Perf::IPSResult @avg=50000 " \
                                 "@stdev=0 @iter=150000 @dt=3>")
  end
end
