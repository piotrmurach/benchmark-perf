# frozen_string_literal: true

RSpec.describe Benchmark::Perf::CPUResult do
  it "defaults all calculations to zero" do
    result = described_class.new

    expect(result.avg).to eq(0)
    expect(result.stdev).to eq(0)
    expect(result.dt).to eq(0)
  end

  it "adds measurements correctly" do
    result = described_class.new

    result << 0.5
    result << 3
    result << 2.5

    expect(result.avg).to eq(2.0)
    expect(result.stdev).to be < 1.1
    expect(result.dt).to eq(6.0)

    result << 0.5

    expect(result.avg).to eq(1.625)
    expect(result.stdev).to be < 1.14
    expect(result.dt).to eq(6.5)
  end

  it "inpsects content" do
    result = described_class.new

    result.add 1.5
    result.add 2.5

    expect(result.inspect).to eq("#<Benchmark::Perf::CPUResult @avg=2.0 " \
                                 "@stdev=0.5 @dt=4.0>")
  end
end
