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
    def self.average(measurements)
      return 0 if measurements.empty?
      measurements.reduce(&:+).to_f / measurements.size
    end

    # Calculate variance of measurements
    #
    # @param [Array[Float]] measurements
    #
    # @return [Float]
    #
    # @api public
    def self.variance(measurements)
      return 0 if measurements.empty?
      avg = average(measurements)
      total = measurements.reduce(0) do |sum, x|
        sum + (x - avg)**2
      end
      total.to_f / measurements.size
    end

    # Calculate standard deviation
    #
    # @param [Array[Float]] measurements
    #
    # @api public
    def self.std_dev(measurements)
      return 0 if measurements.empty?
      Math.sqrt(variance(measurements))
    end

    # Run given work and gather time statistics
    #
    # @param [Float] threshold
    #
    # @return [Boolean]
    #
    # @api public
    def self.assert_perform_under(threshold, options = {}, &work)
      bench = ExecutionTime.new(options)
      actual, _ = bench.run(&work)
      actual <= threshold
    end

    # Assert work is performed within expected iterations per second
    #
    # @param [Integer] iterations
    #
    # @return [Boolean]
    #
    # @api public
    def self.assert_perform_ips(iterations, options = {}, &work)
      bench = Iteration.new(options)
      mean, stddev, _ = bench.run(&work)
      iterations <= (mean + 3 * stddev)
    end
  end # Perf
end # Benchmark
