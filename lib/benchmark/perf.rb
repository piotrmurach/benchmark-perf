# frozen_string_literal: true

require_relative "perf/execution_time"
require_relative "perf/iteration"
require_relative "perf/version"

module Benchmark
  module Perf
    # Run given work and gather time statistics
    #
    # @param [Float] threshold
    #
    # @return [Boolean]
    #
    # @api public
    def assert_perform_under(threshold, **options, &work)
      actual, _ = ExecutionTime.run(**options, &work)
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
    def assert_perform_ips(iterations, **options, &work)
      mean, stddev, _ = Iteration.run(**options, &work)
      iterations <= (mean + 3 * stddev)
    end
    module_function :assert_perform_ips
  end # Perf
end # Benchmark
