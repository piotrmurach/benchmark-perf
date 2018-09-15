# frozen_string_literal: true

module Benchmark
  module Perf
    # Measure number of iterations a work could take in a second
    #
    # @api private
    class Iteration
      MICROSECONDS_PER_SECOND = 1_000_000
      MICROSECONDS_PER_100MS = 100_000

      def initialize(options = {})
        @time   = options.fetch(:time) { 2 } # Default 2 seconds for measurement
        @warmup = options.fetch(:warmup) { 1 }
      end

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

      # Warmup run
      #
      # @api private
      def run_warmup(&work)
        GC.start
        target = Time.now + @warmup
        iter = 0

        elapsed_time = ::Benchmark.realtime do
          while Time.now < target
            call_times(1, &work)
            iter += 1
          end
        end

        elapsed_time *= MICROSECONDS_PER_SECOND
        cycles_per_100ms(iter, elapsed_time)
      end

      # Run measurements
      #
      # @api public
      def run(&work)
        target = Time.now + @time
        iter = 0
        measurements = []
        cycles = run_warmup(&work)

        GC.start

        while Time.now < target
          time = ::Benchmark.realtime { call_times(cycles, &work) }
          next if time <= 0.0 # Iteration took no time
          iter += cycles
          measurements << time * MICROSECONDS_PER_SECOND
        end

        ips = measurements.map do |time_ms|
          (cycles / time_ms) * MICROSECONDS_PER_SECOND
        end

        final_time = Time.now
        elapsed_time = (final_time - target).abs

        [Perf.average(ips).round, Perf.std_dev(ips).round, iter, elapsed_time]
      end
    end # Iteration
  end # Perf
end # Benchmark
