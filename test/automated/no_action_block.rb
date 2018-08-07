require_relative 'automated_init'

context "Cycle" do
  context "Actuate Without Block" do
    cycle = Cycle.build

    test "Is an error" do
      assert proc {cycle.()} do
        raises_error? Cycle::Error
      end
    end
  end
end
