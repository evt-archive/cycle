require_relative '../../interactive_init'

context "Action Got No Result" do
  context "No Timeout" do
    cycle = Cycle.build

    cycles = nil
    result = cycle.() do |i|
      cycles = i + 1
      nil
    end

    fail "Polling should never exit"
  end
end
