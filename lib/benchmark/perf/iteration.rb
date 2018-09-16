# frozen_string_literal: true

module Benchmark
  module Perf
    # Measure number of iterations a work could take in a second
    #
    # @api private
    module Iteration
      MICROSECONDS_PER_SECOND = 1_000_000
      MICROSECONDS_PER_100MS = 100_000

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
        cycles = (iterations * (MICROSECONDS_PER_100MS / elapsed_time)).to_i
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
        target = Perf.time_now + warmup
        iter = 0

        elapsed_time = Perf.clock_time do
          while Perf.time_now < target
            call_times(1, &work)
            iter += 1
          end
        end

        elapsed_time *= MICROSECONDS_PER_SECOND
        cycles_per_100ms(iter, elapsed_time)
      end
      module_function :run_warmup

      # Run measurements
      #
      # @param [Numeric] time
      #   the time to run measurements for
      #
      # @api public
      def run(time: 2, warmup: 1, &work)
        target = Time.now + time
        iter = 0
        measurements = []
        cycles = run_warmup(warmup: warmup, &work)

        GC.start

        while Time.now < target
          bench_time = Perf.clock_time { call_times(cycles, &work) }
          next if bench_time <= 0.0 # Iteration took no time
          iter += cycles
          measurements << bench_time * MICROSECONDS_PER_SECOND
        end

        ips = measurements.map do |time_ms|
          (cycles / time_ms) * MICROSECONDS_PER_SECOND
        end

        final_time = Time.now
        elapsed_time = (final_time - target).abs

        [Perf.average(ips).round, Perf.std_dev(ips).round, iter, elapsed_time]
      end
      module_function :run
    end # Iteration
  end # Perf
end # Benchmark
