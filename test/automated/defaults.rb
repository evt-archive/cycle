require_relative 'automated_init'

context "Cycle" do
  context "Defaults" do
    cycle = Cycle.build(interval_milliseconds: nil, timeout_milliseconds: nil)

    context "Interval Milliseconds" do
      default_interval_milliseconds = Cycle::Defaults.interval_milliseconds

      test "#{default_interval_milliseconds}" do
        assert(cycle.interval_milliseconds = default_interval_milliseconds)
      end
    end

    context "Delay Condition" do
      default_delay_condition = Cycle::Defaults.delay_condition

      test "#{default_delay_condition}" do
        assert(cycle.delay_condition = default_delay_condition)
      end
    end
  end
end
