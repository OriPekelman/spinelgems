# smoke: proxylocal 0.3.1
# Exercises ProxyLocal module-level logger accessor and Protocol#receive_object
# dispatch logic (arity-aware routing + fallback to receive_unknown).
# All external deps (bert, eventmachine) are stubbed so no network/EM needed.

# --- stub external gems so autoloads never fire ---
$LOADED_FEATURES << 'bert'
$LOADED_FEATURES << 'eventmachine'

module BERT
  class Tuple < Array
    def self.[](*args); new(args); end
  end
end

module EventMachine
  module Protocols
    module ObjectProtocol; end
  end
end

require 'proxylocal'
require 'proxylocal/protocol'

# 1. Module-level logger accessor
puts ProxyLocal.logger.inspect       # nil before assignment

ProxyLocal.logger = :custom_logger
puts ProxyLocal.logger.inspect       # :custom_logger after assignment

ProxyLocal.logger = nil
puts ProxyLocal.logger.inspect       # nil after reset

# 2. Protocol#receive_object — dispatch routing
class Dispatcher
  include ProxyLocal::Protocol

  attr_reader :log

  def initialize
    @log = []
  end

  # arity == 1 (exact)
  def receive_ping(host)
    @log << "ping:#{host}"
  end

  # arity == 2 (exact)
  def receive_stream(id, data)
    @log << "stream:#{id}=#{data}"
  end

  # arity == -1 (splat: accepts any count)
  def receive_any(*args)
    @log << "any:#{args.length}"
  end

  def receive_unknown(obj)
    @log << "unknown:#{obj.inspect}"
  end
end

d = Dispatcher.new

# exact arity match -> dispatched
d.receive_object([:ping, 'example.com'])
d.receive_object([:stream, 42, 'hello'])

# splat handler accepts 0, 1, many args
d.receive_object([:any])
d.receive_object([:any, 'x'])
d.receive_object([:any, 'x', 'y', 'z'])

# arity mismatch -> receive_unknown
d.receive_object([:ping, 'host1', 'host2'])  # receive_ping arity=1, got 2
d.receive_object([:stream, 1])               # receive_stream arity=2, got 1

# no receive_foo method -> receive_unknown
d.receive_object([:halt])

# non-array input is wrapped in array then dispatched as unknown
d.receive_object(:bare_symbol)

d.log.each { |entry| puts entry }

# 3. VERSION constant
puts ProxyLocal::VERSION
