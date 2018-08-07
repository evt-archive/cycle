require_relative '../../automated_init'

context "Telemetry" do
  context "Common" do
    context "Action Got Immediate Result" do
      timeout_milliseconds = 0
      cycle = Cycle.build(timeout_milliseconds: timeout_milliseconds)

      sink = Cycle.register_telemetry_sink(cycle)

      cycle.() do
        :something
      end

      test "Recorded got result" do
        assert(sink.recorded_got_result?)
      end

      test "Didn't record delayed" do
        refute(sink.recorded_delayed?)
      end

      test "Didn't record timed out" do
        refute(sink.recorded_timed_out?)
      end
    end
  end
end
