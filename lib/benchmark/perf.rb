# frozen_string_literal: true

require 'benchmark'

require_relative 'perf/execution_time'
require_relative 'perf/iteration'
require_relative 'perf/version'

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
    module_function :average

    # Calculate variance of measurements
    #
    # @param [Array[Float]] measurements
    #
    # @return [Float]
    #
    # @api public
    def variance(measurements)
      return 0 if measurements.empty?
      avg = average(measurements)
      total = measurements.reduce(0) do |sum, x|
        sum + (x - avg)**2
      end
      total.to_f / measurements.size
    end
    module_function :variance

    # Calculate standard deviation
    #
    # @param [Array[Float]] measurements
    #
    # @api public
    def std_dev(measurements)
      return 0 if measurements.empty?
      Math.sqrt(variance(measurements))
    end
    module_function :std_dev

    # Run given work and gather time statistics
    #
    # @param [Float] threshold
    #
    # @return [Boolean]
    #
    # @api public
    def assert_perform_under(threshold, options = {}, &work)
      actual, _ = ExecutionTime.run(options, &work)
      actual <= threshold
    end
    module_function :assert_perform_under

    # Assert work is performed within expected iterations per second
    #
    # @param [Integer] iterations
    #
    # @return [Boolean]
    #
    # @api public
    def assert_perform_ips(iterations, options = {}, &work)
      mean, stddev, _ = Iteration.run(options, &work)
      iterations <= (mean + 3 * stddev)
    end
    module_function :assert_perform_ips

    if defined?(Process::CLOCK_MONOTONIC)
      # Object representing current time
      def time_now
        Process.clock_gettime Process::CLOCK_MONOTONIC
      end
      module_function :time_now
    else
      # Object represeting current time
      def time_now
        Time.now
      end
      module_function :time_now
    end

    # Measure time elapsed with a monotonic clock
    #
    # @public
    def clock_time
      before = time_now
      yield
      after = time_now
      after - before
    end
    module_function :clock_time
  end # Perf
end # Benchmark
