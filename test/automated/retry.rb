require_relative 'automated_init'

context "Cycle" do
  context "Retry when action yields no result" do
    cycle = Cycle.build(maximum_milliseconds: 1, timeout_milliseconds: 2)
    sink = Cycle.register_telemetry_sink(cycle)

    action = proc { nil }

    res = cycle.(&action)

    test "Cycle's result is the return value of the action" do
      assert(res.nil?)
    end

    test "Didn't get result" do
      refute(sink.recorded_got_result?)
    end

    test "Delayed before retrying" do
      assert(sink.recorded_delayed? { |record| record.data == 1 })
    end

    test "Timed out" do
      assert(sink.recorded_timed_out?)
    end
  end

  context "No retry when action yields results" do
    cycle = Cycle.build(maximum_milliseconds: 1, timeout_milliseconds: 2)
    sink = Cycle.register_telemetry_sink(cycle)

    action = proc { :something }

    res = cycle.(&action)

    test "Cycle's result is the return value of the action" do
      assert(res == :something)
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
