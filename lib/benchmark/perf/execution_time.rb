# encoding: utf-8

module Benchmark
  module Perf
    # Measure length of time the work could take on average
    #
    # @api private
    class ExecutionTime
      attr_reader :io

      # @param options :warmup
      #   the number of cycles for warmup, default 1
      #
      def initialize(options = {})
        @io = options.fetch(:io) { nil }
        @samples = options.fetch(:samples) { 30 }
      end

      # Set of ranges in linear progression
      #
      # @api private
      def linear_range(min, max, step = 1)
        (min..max).step(step).to_a
      end

      def bench_range
        linear_range(1, @samples)
      end

      # Isolate run in subprocess
      #
      # @api private
      def run_in_subprocess
        return yield unless Process.respond_to?(:fork)

        reader, writer = IO.pipe
        pid = Process.fork do
          GC.start
          GC.disable if ENV['BENCH_DISABLE_GC']
          reader.close

          time = yield

          io.print "%9.6f" % time if io
          writer.write(Marshal.dump(time))
          GC.enable if ENV['BENCH_DISABLE_GC']
          exit!(0) # run without hooks
        end

        writer.close
        Process.waitpid(pid)
        Marshal.load(reader.read)
      end

      def run_warmup(&work)
        run_in_subprocess { ::Benchmark.realtime(&work) }
      end

      # Perform work x times
      #
      # @api public
      def run(times = (not_set = true), &work)
        range = not_set ? bench_range : (0..times)
        measurements = []
        run_warmup(&work)

        range.each do
          GC.start

          measurements << run_in_subprocess do
            ::Benchmark.realtime(&work)
          end
        end
        io.puts if io

        [Perf.average(measurements), Perf.std_dev(measurements)]
      end
    end # ExecutionTime
  end # Perf
end # Benchmark
