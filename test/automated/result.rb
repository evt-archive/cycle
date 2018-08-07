require_relative 'automated_init'

context "Cycle's Result" do
  cycle = Cycle.build

  result = cycle.() do
    :something
  end

  test "Is the action's result" do
    assert(result == :something)
  end
end
