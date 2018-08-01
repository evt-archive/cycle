require_relative 'automated_init'

context "Cycle" do
  context "Defaults" do
    cycle = Cycle.build(interval_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil)

pp cycle

fail if cycle.interval_milliseconds != 0
      # fail "Interval should be 0, not 200"


    context "Interval Milliseconds" do
      default_interval_milliseconds = Cycle::Defaults.interval_milliseconds

      test "#{default_interval_milliseconds}" do
        assert(cycle.interval_milliseconds == default_interval_milliseconds)
      end
    end

    context "Timeout Milliseconds" do
      default_timeout_milliseconds = Cycle::Defaults.interval_milliseconds

      test "#{default_timeout_milliseconds}" do
        assert(cycle.timeout_milliseconds == default_timeout_milliseconds)
      end
    end

    context "Delay Condition" do
      default_delay_condition = Cycle::Defaults.delay_condition

      test "#{default_delay_condition}" do
        refute(cycle.delay_condition.nil?)
      end
    end
  end
end
