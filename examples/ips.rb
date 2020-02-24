# frozen_string_literal: true

require_relative "../lib/benchmark/perf"

res = Benchmark::Perf.ips(warmup: 0.1, time: 1) do
  "foo" + "bar"
end

puts res.to_a
