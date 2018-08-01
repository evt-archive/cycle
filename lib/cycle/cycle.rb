class Cycle
  Error = Class.new(RuntimeError)

  include Log::Dependency

  dependency :clock, Clock::UTC
  dependency :telemetry, Telemetry

  attr_writer :interval_milliseconds
  def interval_milliseconds
    @interval_milliseconds ||= Defaults.interval_milliseconds
  end

  attr_writer :delay_condition
  def delay_condition
    @delay_condition ||= Defaults.delay_condition
  end

  initializer :timeout_milliseconds

  def self.build(interval_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil)
    if interval_milliseconds.nil? && timeout_milliseconds.nil?
      return none
    end

    new(timeout_milliseconds).tap do |instance|
      instance.interval_milliseconds = interval_milliseconds
      instance.delay_condition = delay_condition
      instance.configure
    end
  end

  def self.configure(receiver, attr_name: nil, interval_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil, cycle: nil)
    attr_name ||= :cycle

    if !cycle.nil?
      instance = cycle
    else
      instance = build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds, delay_condition: delay_condition)
    end

    receiver.public_send "#{attr_name}=", instance
  end

  def self.none
    None.build
  end

  def configure
    Clock::UTC.configure self
    ::Telemetry.configure self
  end

  def self.call(interval_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil, &action)
    instance = build(interval_milliseconds: interval_milliseconds, timeout_milliseconds: timeout_milliseconds, delay_condition: delay_condition)
    instance.call(&action)
  end

  def call(&action)
    stop_time = nil
    if !timeout_milliseconds.nil?
      stop_time = clock.now + (timeout_milliseconds.to_f / 1000.0)
    end

    logger.trace "Cycling (Interval Milliseconds: #{interval_milliseconds}, Timeout Milliseconds: #{timeout_milliseconds.inspect}, Stop Time: #{clock.iso8601(stop_time)})"

    iteration = -1
    result = nil
    loop do
      iteration += 1
      telemetry.record :cycle, iteration

      action_start_time = clock.now

      result = invoke(iteration, &action)

      if delay_condition.(result)
        logger.debug "Got no results from action (Iteration: #{iteration})"

        now = clock.now

        elapsed_milliseconds = clock.elapsed_milliseconds action_start_time, now

        delay elapsed_milliseconds
      else
        logger.debug "Got results from action (Iteration: #{iteration})"
        telemetry.record :got_result
        break
      end

      if !timeout_milliseconds.nil?
        now = clock.now
        if now >= stop_time
          logger.debug "Timeout has lapsed (Iteration: #{iteration}, Stop Time: #{clock.iso8601(stop_time)}, Timeout Milliseconds: #{timeout_milliseconds})"
          telemetry.record :timed_out, now
          break
        end
      end
    end

    logger.debug "Cycled (Iterations: #{iteration + 1}, Interval Milliseconds: #{interval_milliseconds}, Timeout Milliseconds: #{timeout_milliseconds.inspect}, Stop Time: #{clock.iso8601(stop_time)})"

    return result
  end

## TODO iteration should be nilable
## log output: iteration.inspect (because possible nil)
  def invoke(iteration, &action)
    if action.nil?
      raise Error, "Cycle must be actuated with a block"
    end

    logger.trace "Invoking action (Iteration: #{iteration})"

    result = action.call(iteration)
## action_invoked
## record telemetry data with iteration
    telemetry.record :invoked_action

    logger.debug "Invoked action (Iteration: #{iteration})"

    result
  end

  def delay(elapsed_milliseconds)
    delay_milliseconds = interval_milliseconds - elapsed_milliseconds

    logger.trace "Delaying (Delay Milliseconds: #{delay_milliseconds}, Interval Milliseconds: #{interval_milliseconds}, Elapsed Milliseconds: #{elapsed_milliseconds})"

    if delay_milliseconds <= 0
      logger.debug "Elapsed time exceeds or equals interval. Not delayed. (Delay Milliseconds: #{delay_milliseconds}, Interval Milliseconds: #{interval_milliseconds}, Elapsed Milliseconds: #{elapsed_milliseconds})"
      return
    end

    delay_seconds = (delay_milliseconds.to_f / 1000.0)

    sleep delay_seconds

    telemetry.record :delayed, delay_milliseconds

    logger.debug "Finished delaying (Delay Milliseconds: #{delay_milliseconds}, Interval Milliseconds: #{interval_milliseconds}, Delayed Milliseconds: #{delay_milliseconds})"
  end

  def self.register_telemetry_sink(cycle)
    sink = Telemetry.sink
    cycle.telemetry.register(sink)
    sink
  end

  module Telemetry
    class Sink
      include ::Telemetry::Sink

      record :cycle
      record :invoked_action
      record :got_result
      record :delayed
      record :timed_out
    end

    def self.sink
      Sink.new
    end
  end

  module Substitute
    def self.build
      Cycle::None.build.tap do |instance|
        sink = Cycle.register_telemetry_sink(instance)
        instance.telemetry_sink = sink
      end
    end

## Only needed to put sink on substitute
    # class Cycle < None
    #   attr_accessor :telemetry_sink
    # end
  end

  class None < Cycle
## TODO Remove when substitute uses it's own None
    attr_accessor :telemetry_sink

## TODO can use splat placeholders here to indicate args non-significant
    def self.build(interval_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil)
      new(timeout_milliseconds).tap do |instance|
        instance.configure
      end
    end

## TODO Remove when invoke call is in place
    # def call(&action)
    #   action.call
    # end

## TODO Call invoke
    def call(&action)
      iteration = 0
      invoke(iteration, &action)
    end
  end

  module Defaults
    def self.interval_milliseconds
      200
    end

    def self.delay_condition
      lambda do |result|
        if result.respond_to? :empty?
          result.empty?
        else
          result.nil?
        end
      end
    end
  end
end
