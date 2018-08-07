require_relative '../../automated_init'

context "Telemetry" do
  context "Common" do
    context "Action Got No Result" do
      interval_milliseconds = 1
      timeout_milliseconds = 0
      cycle = Cycle.build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds)

      sink = Cycle.register_telemetry_sink(cycle)

      cycle.() do
        nil
      end

      test "Didn't record got result" do
        refute(sink.recorded_got_result?)
      end

      test "Recorded delayed" do
        assert(sink.recorded_delayed? do |record|
          record.data == 1
        end)
      end

      test "Recorded timed out" do
        assert(sink.recorded_timed_out? do |record|
          record.data < Clock::UTC.now
        end)
      end
    end
  end
end
