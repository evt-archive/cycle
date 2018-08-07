require_relative '../../interactive_init'

context "Action Got No Result" do
  context "No Timeout" do
    cycle = Cycle.build

    result = cycle.() do |i|
      puts i
      nil
    end

    fail "Polling should never exit"
  end
end
