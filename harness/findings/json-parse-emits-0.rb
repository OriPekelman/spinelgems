# Minimal repro: Spinel's bundled `json` resolves JSON.generate but NOT
# JSON.parse / JSON.pretty_generate — the unresolved calls silently emit 0.
#
#   $ spinel harness/findings/json-parse-emits-0.rb -o /tmp/j.bin && /tmp/j.bin
#   [1,2]      # JSON.generate — correct
#   0          # JSON.parse   — WRONG (CRuby: [1, 2])
#   0          # JSON.parse   — WRONG (CRuby: 42)
#
# Compiler warning (also under SPINEL_GATE_RAISE=1 — it warns, still emits 0):
#   warning: in (top level): cannot resolve call to 'parse' on int (emitting 0)
#
# Found driving the multi_json mirror (spinel-multi_json) through the mirror
# skeleton: dump/encode (JSON.generate) verify byte-identical to the real gem,
# but load/decode (JSON.parse) return 0. Because the value is returned silently
# (no raise), it is a SILENT miscompile — the worst outcome for a mirror, which
# must fail loudly outside its ledger (matz/spinel#1753 condition #3). So the
# mirror is blocked on this, not shippable until parse resolves.
#
# Secondary (situational): the silent-0 return poisons return-type inference of
# an enclosing method whose OTHER branch is a working JSON.generate — observed in
# MultiJson.dump (a module_function branching on an options hash), where the
# compiled `dump` returned 0 even for the generate branch, with a C-level
# `int-conversion` warning on the emitted function. Did not reproduce in a plain
# top-level method with a boolean flag, so the primary bug below is the repro.
require "json"

puts JSON.generate([1, 2])   # CRuby: [1,2]     Spinel: [1,2]  (works)
p    JSON.parse("[1,2]")     # CRuby: [1, 2]    Spinel: 0      (broken)
p    JSON.parse("42")        # CRuby: 42        Spinel: 0      (broken)
