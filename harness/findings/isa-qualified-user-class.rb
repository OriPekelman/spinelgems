# Minimal repro: is_a? with a NAMESPACE-QUALIFIED USER class argument on a
# built-in receiver raises NoMethodError at runtime (should return false).
# Residual variant of matz/spinel#2683 (fixed 2026-07-16): that fix covers
# ::-scoped BUILTIN classes (::Integer, ::String); a qualified USER class
# (Outer::Thing, a ConstantPathNode) still raises.
#
#   $ spinel harness/findings/isa-qualified-user-class.rb -o /tmp/i.bin && /tmp/i.bin
#   CRuby : true / false / true / false
#   Spinel: true / "raise:NoMethodError" / true / "raise:NoMethodError"
#
# Engine git:12b757f0. At 65fb6d2d the same file didn't compile at all
# ("C compilation failed"), so this is a partial improvement, not a regression.
# Surfaced by the addressable mirror: `other.is_a?(Addressable::URI)` — where
# the qualified name is itself the workaround for bare `URI` resolving to the
# stdlib ::URI inside the class body.
module Outer; class Thing; end; end
r1 = (5.is_a?(::Integer) rescue "raise:#{$!.class}")   # fixed by #2683
r2 = ("s".is_a?(Outer::Thing) rescue "raise:#{$!.class}")  # still raises
r3 = ("s".is_a?(::String) rescue "raise:#{$!.class}")  # fixed by #2683
r4 = (5.is_a?(Outer::Thing) rescue "raise:#{$!.class}")    # still raises
p r1; p r2; p r3; p r4
