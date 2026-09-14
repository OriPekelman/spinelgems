# Finding: the 91f069f0 always-frozen-literals cluster (all four lost-★ at 76cfd099)

Upstream 91f069f0 ("Remove the frozen_string_literal opt-out: literals are
always frozen", 12b757f0→76cfd099 window, deliberate) produces two observable
shapes, which together account for ALL FOUR behaviour-lost ★ of the 76cfd099
harness pass:

1. **Observability** (pygmentize, t2-web): `V = "s"; V.frozen?` → CRuby
   (chilled, no magic comment) false, Spinel true. 2-line repro; 12b757f0
   still said false. NOT a gem defect — our smokes were asserting CRuby's
   *current* chilled semantics, which CRuby itself plans to drop. RESOLVED by
   removing the `.frozen?` assertions from the two smokes; both gems re-earn ★
   at 76cfd099 (catalog patched: ★322).

2. **Mutation** (quotemedia, roman-numerals): gem code mutates a string
   literal → `can't modify frozen String` at runtime under Spinel, works
   (with chilled warnings) under CRuby. These stay REJECTED — the gems'
   own code genuinely breaks under always-frozen semantics.

DISPOSITION: accepted divergence, not filable — the commit message is the
declaration of intent, and it aligns with Ruby's announced frozen-by-default
future. Smoke-authoring rule going forward: never assert `.frozen?` on
literal-derived values. Watch future sweeps for a wider literal-mutation
cluster (only smoked gems can reveal it; compile+scan can't see runtime
mutation).
