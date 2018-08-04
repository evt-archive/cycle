require_relative 'automated_init'

context "Cycle's Result" do
  cycle = Cycle.build

  cycles = nil
  result = cycle.() do |i|
    cycles = i + 1

    :something
  end

  test "Is the action's result" do
    assert(result == :something)
  end
end
