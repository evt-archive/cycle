require_relative 'automated_init'

context "Cycle" do
  context "Action Got Result" do
    ## TODO What should the args be here?
    cycle = Cycle.build(interval_milliseconds: 0, timeout_milliseconds: 100)

    result = cycle.() do
      :some_result
    end

    test "Cycle is executed once" do
      assert(result == :some_result)
    end
  end
end
