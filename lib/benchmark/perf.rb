# encoding: utf-8

require 'benchmark'

require 'benchmark/perf/execution_time'
require 'benchmark/perf/iteration'
require 'benchmark/perf/version'

module Benchmark
  module Perf
    # Calculate arithemtic average of measurements
    #
    # @param [Array[Float]] measurements
    #
    # @return [Float]
    #   the average of given measurements
    #
    # @api public
    def average(measurements)
      return 0 if measurements.empty?
      measurements.reduce(&:+).to_f / measurements.size
    end

    # Calculate standard deviation
    #
    # @param [Array[Float]] measurements
    #
    # @api public
    def std_dev(measurements)
      return 0 if measurements.empty?
      average = average(measurements)
      Math.sqrt(
        measurements.reduce(0) do |sum, x|
          sum + (x - average)**2
        end.to_f / (measurements.size - 1)
      )
    end

    # Run given work and gather time statistics
    #
    # @api public
    def assert_perform_under(threshold, options = {}, &work)
      bench = ExecutionTime.new(options)
      actual, _ = bench.run(&work)
      actual <= threshold
    end

    # Assert work is performed within expected iterations per second
    #
    # @api public
    def assert_perform_ips(iterations, options = {}, &work)
      bench = Iteration.new(options)
      mean, stddev, _ = bench.run(&work)
      iterations <= (mean + 3 * stddev)
    end

    extend Benchmark::Perf
  end # Perf
end # Benchmark
