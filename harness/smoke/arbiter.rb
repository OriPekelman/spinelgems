# Smoke: Arbiter pub/sub message routing

class ListenerAlpha
  def subscribe_to; [:ping, :pong]; end
  def notify(msg, meta); puts "a:#{msg}:#{meta}"; end
end

class ListenerBeta
  def subscribe_to; [:ping]; end
  def notify(msg, meta); puts "b:#{msg}:#{meta}"; end
end

Arbiter.set_listeners([ListenerAlpha.new, ListenerBeta.new])
Arbiter.publish(:ping, "x")
Arbiter.publish(:pong, "y")
Arbiter.publish(:unknown, "z")

class ListenerGamma
  def subscribe_to; [:done]; end
  def notify(msg, meta); puts "done:#{meta}"; end
end

Arbiter.set_listeners([ListenerGamma.new])
Arbiter.perform(:done, "finish")
