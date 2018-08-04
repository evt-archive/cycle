require_relative '../../automated_init'

context "Action Got Immediate Result" do
  cycle = Cycle.build

  cycles = nil
  cycle.() do |i|
    cycles = i + 1

    :something
  end

  test "Cycle is executed once and then exits (Cycles: #{cycles})" do
    assert(cycles == 1)
  end
end
