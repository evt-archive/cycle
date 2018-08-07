require_relative '../../automated_init'

context "Telemetry" do
  context "Common" do
    timeout_milliseconds = 0
    cycle = Cycle.build(timeout_milliseconds: timeout_milliseconds)

    sink = Cycle.register_telemetry_sink(cycle)

    cycle_milliseconds = 1
    cycle.() do
      sleep cycle_milliseconds/1000.0
    end

    test "Recorded cycle" do
      recorded_cycle = sink.recorded_cycle? do |record|
        record.data == 0
      end

      assert(recorded_cycle)
    end

    test "Recorded invoked action" do
      recorded_invoked_action = sink.recorded_invoked_action? do |record|
        record.data >= cycle_milliseconds
      end

      assert(recorded_invoked_action)
    end
  end
end
