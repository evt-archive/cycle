require_relative '../../automated_init'

context "Telemetry" do
  context "Common" do
    timeout_milliseconds = 0
    cycle = Cycle.build(timeout_milliseconds: timeout_milliseconds)

    sink = Cycle.register_telemetry_sink(cycle)

    cycle.() { }

    test "Recorded cycle" do
      recorded_cycle = sink.recorded_cycle? do |record|
        record.data == 0
      end

      assert(recorded_cycle)
    end

    test "Recorded invoked action" do
      assert(sink.recorded_invoked_action?)
    end
  end
end
