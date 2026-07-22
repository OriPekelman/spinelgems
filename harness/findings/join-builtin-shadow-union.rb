# Minimal repro: a user method named `join` mis-dispatches when its receiver
# type is a String-including union — the builtin `join` signature wins and the
# call's result type collapses to String (ty6), so member access on the result
# fails to compile:
#
#   join-builtin-shadow-union.rb:17: unsupported puts argument:
#     node 59 (CallNode `host`) recv=LocalVariableReadNode/ty6 argc=0
#
# TWO ingredients, each harmless alone (verified matrix, engine git:12b757f0):
#   * rename join -> qjoin (same body)            => compiles, prints "c"
#   * drop `return uri if uri.is_a?(URI)`         => compiles, prints "c"
#
# The union arm is PHANTOM: every parse call site passes a String, so the
# is_a?(URI) guard can never return a String at runtime — but the analyzer
# types the guarded `return uri` from the param's static type (String) instead
# of narrowing to URI, making parse : String|URI. Dispatching `.join` on that
# union then prefers the builtin name over the user method.
#
# Root shape behind the "addressable inference ceiling" (mirror paused on
# public .join since engine 65fb6d2d; reduced from the 167-line mirror with
# spinel-reduce + a semantic oracle).
module Addressable
  class URI
    attr_reader :host
    def self.parse(uri)
      return uri if uri.is_a?(URI)
      new(uri.to_s)
    end
    def initialize(host)
      @host = host
    end
    def join(other)
      URI.new(URI.parse(other.to_s).host)
    end
  end
end
j = Addressable::URI.parse("h").join("c")
puts j.host   # CRuby: "c"
