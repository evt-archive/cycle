require_relative '../automated_init'

context "Interval" do
  context "Cycle time is less than the interval time" do
    interval_milliseconds = 100
    cycle = Cycle.build(interval_milliseconds: interval_milliseconds)

    start_time = Time.now

    iterations = nil
    result = cycle.() do |i|
      iterations = i + 1
      sleep 0.01
      nil
    end

    end_time = Time.now

    elapsed_milliseconds = (end_time - start_time) * 1000

    test "Elapsed time is approximately the interval time  (Elapsed Time: #{elapsed_milliseconds}, Interval Time: #{interval_milliseconds})" do
      assert(elapsed_milliseconds >= interval_milliseconds)
    end
  end
end
