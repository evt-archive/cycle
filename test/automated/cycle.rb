require_relative 'automated_init'

context "Cycle" do
  context "Execute Once" do
    cycle = Cycle.build(interval_milliseconds: 100, timeout_milliseconds: 0)

    iteration = nil
    cycle.() do |i|
      iteration = i
      # nil
    end

    test "Cycle is executed once" do
      assert(iteration == 0)
    end
  end
end
