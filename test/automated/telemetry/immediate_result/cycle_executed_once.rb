require_relative '../../automated_init'

context "Telemetry" do
  context "Action Got Immediate Result" do
    timeout_milliseconds = 0
    cycle = Cycle.build(timeout_milliseconds: timeout_milliseconds)

    sink = Cycle.register_telemetry_sink(cycle)

    result = cycle.() do
      :something
    end

    test "Cycle's result is the return value of the action" do
      assert(result == :something)
    end

    test "Got result" do
      assert(sink.recorded_got_result?)
    end

    test "Did not delay" do
      refute(sink.recorded_delayed?)
    end

    test "Did not timeout" do
      refute(sink.recorded_timed_out?)
    end
  end
end
