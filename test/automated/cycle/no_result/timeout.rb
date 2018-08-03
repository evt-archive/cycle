require_relative '../../automated_init'

context "Cycle" do
  context "Action Got No Result" do
    context "Timeout not Elapsed" do
      cycle = Cycle.build(timeout_milliseconds: 11)

      iterations = nil
      result = cycle.() do |i|
        iterations = i + 1
        nil
      end

      test "Cycles until timeout elapses" do
        assert(iterations > 1)
      end
    end
  end
end
