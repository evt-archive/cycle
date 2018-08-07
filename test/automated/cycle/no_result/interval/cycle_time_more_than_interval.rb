require_relative '../../../automated_init'

context "Cycle" do
  context "Action Got No Result" do
    context "Interval" do
      context "Cycle time is more than the interval time" do
        interval_milliseconds = 0
        timeout_milliseconds = 0
        cycle = Cycle.build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds)

        start_time = Time.now

        cycle_milliseconds = (interval_milliseconds + 1)
        cycle.() do
          sleep cycle_milliseconds / 1000.0
          nil
        end

        end_time = Time.now

        execution_milliseconds = (end_time - start_time) * 1000

        test "Execution takes more time than the interval time (Execution Time: #{execution_milliseconds}, Interval Time: #{interval_milliseconds}, Cycle Time: #{cycle_milliseconds})" do
          assert(execution_milliseconds >= interval_milliseconds)
        end
      end
    end
  end
end
