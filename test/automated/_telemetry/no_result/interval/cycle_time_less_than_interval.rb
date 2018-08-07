require_relative '../../../automated_init'

context "Telemetry" do
  context "Action Got No Result" do
    context "Interval" do
      context "Cycle time is less than the interval time" do
        interval_milliseconds = 1
        timeout_milliseconds = 2
        cycle = Cycle.build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds)

        sink = Cycle.register_telemetry_sink(cycle)

        result = cycle.() do
          nil
        end

        test "Cycle's result is the return value of the action" do
          assert(result.nil?)
        end

        test "Didn't get result" do
          refute(sink.recorded_got_result?)
        end

        test "Delayed before retrying" do
          assert(sink.recorded_delayed?)
        end

        test "Timed out" do
          assert(sink.recorded_timed_out?)
        end
      end
    end
  end
end
