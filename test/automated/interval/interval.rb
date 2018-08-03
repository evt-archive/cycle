require_relative '../automated_init'

context "Interval" do
  context "Interval is Less Than the Timeout" do
    interval_milliseconds = 150
    timeout_milliseconds = 200
    cycle = Cycle.build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds)

    start_time = Time.now

    iterations = nil
    result = cycle.() do |i|
      iterations = i + 1
      sleep 0.101
      nil
    end

    end_time = Time.now

    elapsed_milliseconds = (end_time - start_time) * 1000

    test "(Elapsed Time: #{elapsed_milliseconds}, Interval Time: #{interval_milliseconds})" do
      assert(elapsed_milliseconds >= interval_milliseconds)
    end
  end
end
