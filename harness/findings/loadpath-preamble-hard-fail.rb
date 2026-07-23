# Corpus finding (engine git:12b757f0): the classic pre-bundler preamble
#
#   $:.unshift File.dirname(__FILE__)
#
# hard-fails analysis as `unsupported global variable read
# (GlobalVariableReadNode)` — the whole gem rejects on line 1. It is the
# dominant cluster in the 42adf886 -> 12b757f0 catalog movement: 5,418
# previously clean/risky gems went rejected:analyze-failed, and ~46% of a
# 800-gem sample open with this exact preamble.
#
# NOT a capability regression: at 65fb6d2d the same file COMPILED but died at
# RUNTIME on line 1 (`undefined method 'unshift' for unknown`) — so those gems
# were silently broken; 12b757f0 refuses loudly. Same stricter+honest shape as
# the #1605 wave. Possibly fallout of the fe08f5ef -> 3131ad6c predefined-
# globals add/revert cycle.
#
# FILED as matz/spinel#3284 (2026-07-23).
# The upstream ASK is design, not bugfix: no-op the load-path preamble
# ($: / $LOAD_PATH unshift/push/<<) with a warning, the same way an
# unresolvable `require` is ignored-with-warning. Load-path manipulation is
# meaningless under AOT no-load-path semantics, and the symmetry would turn
# the whole cluster back into probeable gems.
#
#   $ spinel harness/findings/loadpath-preamble-hard-fail.rb -o /tmp/lp.bin
#   12b757f0: line 1: unsupported global variable read (compile refusal)
#   65fb6d2d: compiles; runtime NoMethodError on line 1 (silent bomb)
#   CRuby   : prints 1
$:.unshift File.dirname(__FILE__)
puts 1
