# frozen_string_literal: true

module Benchmark
  module Perf
    # Measure length of time the work could take on average
    #
    # @api public
    module ExecutionTime
      # Set of ranges in linear progression
      #
      # @api public
      def linear_range(min, max, step = 1)
        (min..max).step(step).to_a
      end
      module_function :linear_range

      # Isolate run in subprocess
      #
      # @example
      #   iteration.run_in_subproces { ... }
      #
      # @return [Float]
      #   the elapsed time of the measurement
      #
      # @api private
      def run_in_subprocess(io: nil)
        return yield unless Process.respond_to?(:fork)

        reader, writer = IO.pipe
        pid = Process.fork do
          GC.start
          GC.disable if ENV['BENCH_DISABLE_GC']

          begin
            reader.close
            time = yield

            io.print "%9.6f" % data if io
            Marshal.dump(time, writer)
          rescue => error
            Marshal.dump(error, writer)
          ensure
            GC.enable if ENV['BENCH_DISABLE_GC']
            exit!(0) # run without hooks
          end
        end

        writer.close unless writer.closed?
        Process.waitpid(pid)
        data = Marshal.load(reader)
        raise data if data.is_a?(Exception)
        data
      end
      module_function :run_in_subprocess

      # Run warmup measurement
      #
      # @param [Numeric] warmup
      #   the warmup time
      #
      # @api private
      def run_warmup(warmup: 1, &work)
        GC.start
        warmup.times do
          run_in_subprocess do
            ::Benchmark.realtime(&work)
          end
        end
      end
      module_function :run_warmup

      # Perform work x times
      #
      # @param [Integer] times
      #   how many times sample the code measuremenets
      #
      # @example
      #   ExecutionTime.run(times: 10) { ... }
      #
      # @return [Array[Float, Float]]
      #   average and standard deviation
      #
      # @api public
      def run(times: 30, io: nil, warmup: 1, &work)
        range = linear_range(1, times - 1)
        measurements = []
        run_warmup(warmup: warmup, &work)

        range.each do
          GC.start
          measurements << run_in_subprocess(io: io) do
            ::Benchmark.realtime(&work)
          end
        end
        io.puts if io

        [Perf.average(measurements), Perf.std_dev(measurements)]
      end
      module_function :run
    end # ExecutionTime
  end # Perf
end # Benchmark
