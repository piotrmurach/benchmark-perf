# frozen_string_literal: true

require_relative "clock"

module Benchmark
  module Perf
    # Measure number of iterations a work could take in a second
    #
    # @api private
    module Iteration
      # Call work by given times
      #
      # @param [Integer] times
      #   the times to call
      #
      # @return [Integer]
      #   the number of times worke has been called
      #
      # @api private
      def call_times(times)
        i = 0
        while i < times
          yield
          i += 1
        end
      end
      module_function :call_times

      # Calcualte the number of cycles needed for 100ms
      #
      # @param [Integer] iterations
      # @param [Float] elapsed_time
      #   the total time for all iterations
      #
      # @return [Integer]
      #   the cycles per 100ms
      #
      # @api private
      def cycles_per_100ms(iterations, elapsed_time)
        cycles = (iterations * (Clock::MICROSECONDS_PER_100MS / elapsed_time)).to_i
        cycles <= 0 ? 1 : cycles
      end
      module_function :cycles_per_100ms

      # Warmup run
      #
      # @param [Numeric] warmup
      #   the number of seconds for warmup
      #
      # @api private
      def run_warmup(warmup: 1, &work)
        GC.start

        target = Clock.now + warmup
        iter = 0

        elapsed_time = Clock.measure do
          while Clock.now < target
            call_times(1, &work)
            iter += 1
          end
        end

        elapsed_time *= Clock::MICROSECONDS_PER_SECOND
        cycles_per_100ms(iter, elapsed_time)
      end
      module_function :run_warmup

      # Run measurements
      #
      # @param [Numeric] time
      #   the time to run measurements in seconds
      # @param [Numeric] warmup
      #   the warmup time in seconds
      #
      # @api public
      def run(time: 2, warmup: 1, &work)
        cycles = run_warmup(warmup: warmup, &work)

        GC.start

        iter = 0
        measurements = []

        target = (before = Clock.now) + time

        while Clock.now < target
          bench_time = Clock.measure { call_times(cycles, &work) }
          next if bench_time <= 0.0 # Iteration took no time
          iter += cycles
          measurements << bench_time * Clock::MICROSECONDS_PER_SECOND
        end

        ips = measurements.map do |time_ms|
          (cycles / time_ms) * Clock::MICROSECONDS_PER_SECOND
        end

        final_time = Clock.now
        elapsed_time = (final_time - before).abs

        [Perf.average(ips).round, Perf.std_dev(ips).round, iter, elapsed_time]
      end
      module_function :run
    end # Iteration
  end # Perf
end # Benchmark
