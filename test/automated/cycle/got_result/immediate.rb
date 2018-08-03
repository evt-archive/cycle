require_relative '../../automated_init'

context "Cycle" do
  context "Action Got Result" do
    context "Immediate Result" do
      cycle = Cycle.build

      iterations = nil
      result = cycle.() do |i|
        iterations = i + 1
        i
      end

      test "Cycle is executed once and then exits" do
        assert(iterations == 1)
      end
    end
  end
end
