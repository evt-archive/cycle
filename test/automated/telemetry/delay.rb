require_relative 'automated_init'

context "Cycle" do
  context "Delay" do
    context "No time elapses during action" do
      cycle = Cycle.build(interval_milliseconds: 1, timeout_milliseconds: 2)
      sink = Cycle.register_telemetry_sink(cycle)

      action = proc { nil }

      cycle.(&action)

      test "Cycle is delayed by interval milliseconds" do
        assert(sink.recorded_delayed? { |record| record.data == 1 })
      end
    end

    context "Elapsed time of action is within interval milliseconds" do
      cycle = Cycle.build(interval_milliseconds: 11, timeout_milliseconds: 2)
      elapsed_milliseconds = 10

      sink = Cycle.register_telemetry_sink(cycle)

      clock = SubstAttr::Substitute.(:clock, cycle)

      clock.now = Controls::Time::Raw.example

      action = proc {
        clock.now = Controls::Time::Offset::Raw.example elapsed_milliseconds
        nil
      }

      cycle.(&action)

      test "Cycle is delayed by interval milliseconds less elapsed time" do
        delay_milliseconds = cycle.interval_milliseconds - elapsed_milliseconds

        assert(sink.recorded_delayed? { |record| record.data == delay_milliseconds })
      end
    end

    context "Elapsed time of action exceeds interval milliseconds" do
      cycle = Cycle.build(interval_milliseconds: 11, timeout_milliseconds: 2)
      elapsed_milliseconds = 11

      sink = Cycle.register_telemetry_sink(cycle)

      clock = SubstAttr::Substitute.(:clock, cycle)

      clock.now = Controls::Time::Raw.example

      action = proc {
        clock.now = Controls::Time::Offset::Raw.example elapsed_milliseconds
        nil
      }

      cycle.(&action)

      test "Cycle is not delayed" do
        refute(sink.recorded_delayed?)
      end
    end
  end
end
