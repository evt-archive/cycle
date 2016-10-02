require_relative 'automated_init'

context "Cycle" do
  context "Telemetry" do
    context "Got Result" do
      cycle = Cycle.build(delay_milliseconds: 1, timeout_milliseconds: 2)
      sink = Cycle.register_telemetry_sink(cycle)

      cycle.() do
        'some result'
      end

      test "Recorded cycle" do
        iteration = 0
        assert(sink.recorded_cycle? { |record| record.data == iteration })
      end

      test "Recorded invoked action" do
        assert(sink.recorded_invoked_action?)
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

    context "Got No Result" do
      cycle = Cycle.build(delay_milliseconds: 1, timeout_milliseconds: 2)
      sink = Cycle.register_telemetry_sink(cycle)

      cycle.() do
        nil
      end

      test "Recorded cycle" do
        iteration = 0
        assert(sink.recorded_cycle? { |record| record.data == iteration })
      end

      test "Recorded invoked action" do
        assert(sink.recorded_invoked_action?)
      end

      test "Recorded delayed" do
        assert(sink.recorded_delayed? { |record| record.data == 1 })
      end

      test "Recorded timed out" do
        assert(sink.recorded_timed_out? { |record| record.data < Clock::UTC.now })
      end

      test "Didn't record got result" do
        refute(sink.recorded_got_result?)
      end
    end
  end
end
