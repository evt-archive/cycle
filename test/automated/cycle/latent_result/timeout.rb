require_relative '../../automated_init'

context "Cycle" do
  context "Action Got Result" do
    context "Latent Result" do
      cycle = Cycle.build(timeout_milliseconds: 11)

      iterations = nil
      result = cycle.() do |i|
        iterations = i + 1

        if i > 0
          :something
        end
      end

      test "Cycle is executed until result is produced" do
        assert(iterations == 2)
      end
    end
  end
end
