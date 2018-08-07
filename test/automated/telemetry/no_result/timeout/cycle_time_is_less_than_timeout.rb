require_relative '../../../automated_init'

context "Telemetry" do
  context "Action Got No Result" do
    context "Interval" do
      context "Cycle Time Is Less than the Timeout Time" do
        timeout_milliseconds = 1
        cycle = Cycle.build(timeout_milliseconds: timeout_milliseconds)

        sink = Cycle.register_telemetry_sink(cycle)

        result = cycle.() do |i|
          nil
        end

        test "Cycle's result is the return value of the action" do
          assert(result.nil?)
        end

        test "Didn't get result" do
          refute(sink.recorded_got_result?)
        end

        test "Didn't delay" do
          refute(sink.recorded_delayed?)
        end

        test "Timed out" do
          assert(sink.recorded_timed_out?)
        end
      end
    end
  end
end
