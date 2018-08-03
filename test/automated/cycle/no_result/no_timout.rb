require_relative '../../automated_init'

context "Cycle" do
  context "Action Got No Result" do
    context "No Timeout" do
      cycle = Cycle.build

      iterations = nil
      result = cycle.() do |i|
        iterations = i + 1
        nil
      end

      test "Cycle exits after one execution" do
        assert(iterations == 1)
      end
    end
  end
end
