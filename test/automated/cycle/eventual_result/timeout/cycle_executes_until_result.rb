require_relative '../../../automated_init'

context "Cycle" do
  context "Action Got Eventual Result" do
    context "Timeout" do
      cycle = Cycle.build(timeout_milliseconds: 11)

      cycles = nil
      cycle.() do |i|
        cycles = i + 1

        if i > 0
          :something
        end
      end

      test "Cycle exits when result is produced (Cycles: #{cycles})" do
        assert(cycles == 2)
      end
    end
  end
end
