require_relative '../../../automated_init'

context "Telemetry" do
  context "Action Got No Result" do
    context "Interval" do
      context "Cycle Time Is More than the Interval Time" do
        interval_milliseconds = 0
        timeout_milliseconds = 0
        cycle = Cycle.build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds)

        sink = Cycle.register_telemetry_sink(cycle)

        cycle_milliseconds = interval_milliseconds + 1
        result = cycle.() do
          sleep cycle_milliseconds / 1000.0
          nil
        end

        test "Cycle's result is the return value of the action" do
          assert(result.nil?)
        end

        test "Didn't get result" do
          refute(sink.recorded_got_result?)
        end

        test "Did not delay" do
          refute(sink.recorded_delayed?)
        end

        test "Timed out" do
          assert(sink.recorded_timed_out?)
        end
      end
    end
  end
end
