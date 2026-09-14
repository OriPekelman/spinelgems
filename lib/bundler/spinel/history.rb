require "json"
require "cgi"
require_relative "site"

module Bundler
  module Spinel
    # The historical record: how the catalog shifts as the Spinel compiler
    # evolves. Each "run" is a full corpus re-probe at one engine revision; this
    # renders the verdict-mix timeline + the gem-level deltas between consecutive
    # runs — the bug pipeline closing the loop, made visible.
    class History
      # Ordered runs (oldest→newest). Each: rev, date, the engine commit subject,
      # the full-corpus probe snapshot, and a curated note on what moved.
      RUNS = [
        { rev: "a03bb49", date: "2026-05-28", commit: "the first full-corpus survey (189,742 gems)",
          file: "survey-fresh/compat.jsonl", note: nil },
        { rev: "8d88ebe", date: "2026-05-29", commit: "module/reflection + GC fixes (is_a?, .class, respond_to?, #1052)",
          file: "survey-8d88ebe/compat.jsonl",
          note: "Mixed: the module-object fixes graduated gems, but <code>96b21e6</code> " \
                "(module_function support) <strong>regressed</strong> ~160 gems whose objects " \
                "were built from a variable-held class (the <code>brass</code> cluster) — caught " \
                "by the re-probe and filed as <a href=\"https://github.com/matz/spinel/issues/1062\">matz/spinel#1062</a>." },
        { rev: "f8040f3", date: "2026-05-31", commit: "DCE for synthetic module class methods (#1062 fix), instance_methods const-fold (#1073), Array#transpose, map→array",
          file: "survey-f8040f3/compat.jsonl",
          note: "<strong>Recovery + gains.</strong> matz bisected #1062 to <code>96b21e6</code> and fixed it " \
                "(<code>e2e010c</code>); together with the new <code>instance_methods</code> const-fold " \
                "(<a href=\"https://github.com/matz/spinel/issues/1073\">#1073</a>) and <code>transpose</code>/map " \
                "specializations, the brass cluster and thousands more moved out of <code>rejected</code>." },
        { rev: "95557f5", date: "2026-06-02", commit: "module/class-body side effects + lexical const refs (#1256), Regexp.last_match(n) (#1257), preserve Float-in-Hash (#1258), Struct typing, JSON.generate, alias, +14 more",
          file: "survey-95557f5/compat.jsonl",
          note: "<strong>The biggest single jump yet.</strong> 22 upstream commits — including fixes for three " \
                "issues this harness filed (<a href=\"https://github.com/matz/spinel/issues/1256\">#1256</a> module-body, " \
                "<a href=\"https://github.com/matz/spinel/issues/1257\">#1257</a> <code>Regexp.last_match</code>, " \
                "<a href=\"https://github.com/matz/spinel/issues/1258\">#1258</a> Float-in-Hash) plus Struct typing, " \
                "<code>alias</code>, <code>JSON.generate</code> for records and more — moved <strong>20,175</strong> gems " \
                "out of <code>rejected</code>, among them <code>rspec</code>, <code>globalid</code>, " \
                "<code>mini_portile2</code> and <code>coffee-rails</code>." },
        { rev: "a782696", date: "2026-06-03", commit: "StringScanner unscan/check + Error, Time#to_s + puts-nil, Dir.exist? + alias_method dispatch, missing int-hash keys as nil, RBS extractor heterogeneous-union→poly, subclass-initialize poly unification (13 commits)",
          file: "survey-a782696/compat.jsonl",
          note: "<strong>A consolidation rev.</strong> The base verdict mix is essentially flat after the previous " \
                "jump — 13 upstream commits of correctness fixes (<code>StringScanner</code>, <code>Time#to_s</code>, " \
                "<code>Dir.exist?</code>/<code>alias_method</code>, and the RBS-extractor union→poly change) graduated a " \
                "small set of gems — <code>google-adwords-api</code>, <code>libdatadog</code>, <code>random_user_agent</code>, " \
                "<code>twitter_username_extractor</code> and the <code>redcar-*</code> cluster — while a couple regressed " \
                "and were caught by the re-probe. The bigger story this rev was off the catalog: the harness found " \
                "<code>spinel_analyze</code> consuming 100+ GB on a cluster of auto-generated API-SDK gems (a compiler " \
                "memory blow-up, filed upstream)." },
        { rev: "9c0a5f0", date: "2026-06-04", commit: "79 commits — incl. fixes for 6 harness-filed issues: stdlib-class-in-ivar (#1305), reopen-Object (#1306), lambda/proc branch-local (#1315), &blk+block_given? (#1316), inject(&:sym) (#1317), ignored-require constant (#1273)",
          file: "survey-9c0a5f0/compat.jsonl",
          note: "<strong>The harness loop paying off.</strong> matz landed fixes for <strong>six</strong> issues this " \
                "harness filed the day before — all common idioms: <code>block_given?</code> with a named " \
                "<code>&amp;blk</code> (<a href=\"https://github.com/matz/spinel/issues/1316\">#1316</a>), " \
                "<code>inject(&amp;:+)</code> (<a href=\"https://github.com/matz/spinel/issues/1317\">#1317</a>), " \
                "reopening <code>class Object</code> (<a href=\"https://github.com/matz/spinel/issues/1306\">#1306</a>), " \
                "a stdlib class held in an instance variable " \
                "(<a href=\"https://github.com/matz/spinel/issues/1305\">#1305</a>), and a branch-assigned local inside a " \
                "lambda/proc (<a href=\"https://github.com/matz/spinel/issues/1315\">#1315</a>). <strong>3,487</strong> gems " \
                "moved out of <code>rejected</code> (110.3k→106.8k). The one feature ruled out of scope — aliasing the " \
                "regexp special globals (<a href=\"https://github.com/matz/spinel/issues/1307\">#1307</a>) — now fails with a " \
                "clear diagnostic instead of bad C." },
        { rev: "5c9790c", date: "2026-06-05", commit: "17 commits — fixes for 3 harness-filed typed-collection issues: Hash#fetch on int_int_hash (#1329), Array#join on poly_array (#1332), Class-in-collection→poly (#1337); plus regex line-anchoring/gsub-buffer + first-class string type",
          file: "survey-5c9790c/compat.jsonl",
          note: "<strong>Typed-collection coverage.</strong> matz fixed three issues this harness filed hours earlier — all " \
                "the same shape: a method that exists on the generic path but was missing on a <em>specialized</em> " \
                "collection. <code>Hash#fetch</code> on an int→int hash " \
                "(<a href=\"https://github.com/matz/spinel/issues/1329\">#1329</a>), <code>Array#join</code> on a mixed " \
                "<code>poly_array</code> (<a href=\"https://github.com/matz/spinel/issues/1332\">#1332</a>), and a " \
                "<code>Class</code> value stored in a Hash/Array now typed as poly instead of int " \
                "(<a href=\"https://github.com/matz/spinel/issues/1337\">#1337</a>, which had broken every options-hash " \
                "carrying an exception class). The compile+scan base barely moves on fixes like these — they're " \
                "full-surface/runtime, so the graduation shows in the behaviour-verified tier." },
        { rev: "57af7f9", date: "2026-06-07", commit: "~40 commits — 9 harness-filed issues closed in one wave: the ecosystem-spine front doors (alias→attr_reader #1356, &:sym-after-positional parse #1359), unary operator mangling (#1357), sp_sym_intern link (#1355), plus typed-collection nil steps (#801/#1180) and #line / --emit-symbol-map diagnostics (the #1338 RFC direction)",
          file: "survey-57af7f9/compat.jsonl",
          note: "<strong>The spine-gems wave.</strong> Auditing why <code>bundler</code>/<code>rake</code>/" \
                "<code>minitest</code>/<code>thor</code> reject found two shallow front doors — " \
                "<code>alias</code> to an <code>attr_reader</code>-generated method " \
                "(<a href=\"https://github.com/matz/spinel/issues/1356\">#1356</a>, rake + thor) and " \
                "<code>&amp;:sym</code> after a positional argument mis-parsed as a hash literal " \
                "(<a href=\"https://github.com/matz/spinel/issues/1359\">#1359</a>, bundler + minitest) — and matz closed " \
                "both within a day, alongside 7 more harness filings. All four spine gems now compile past their old " \
                "blockers into distinct second-tier issues " \
                "(<a href=\"https://github.com/matz/spinel/issues/1368\">#1368</a> et al.). C compile errors now map back " \
                "to Ruby source lines via <code>#line</code>, on by default — the " \
                "<a href=\"https://github.com/matz/spinel/issues/1338\">#1338</a> RFC direction. The behaviour-verified " \
                "tier reached 144 mechanical ★ this run." },
        { rev: "cb23cc6", date: "2026-06-09", commit: "~23 commits — 12 harness-filed issues closed in one wave, incl. Mutex/Monitor#synchronize + Thread.new now running and carrying their block value (#1360), class-instance-vars in class methods (#1352), is_a?(IncludedModule)/ancestors (#1350), \\h/\\H regex (#1349), reopened-builtin optional defaults (#1348), bitwise/shift operator mangling (#1358/#1368), the captured-&block value/type family",
          file: "survey-cb23cc6/compat.jsonl",
          note: "<strong>Mutex/Thread come in from the cold.</strong> With matz/spinel#1360 landing " \
                "(<code>Mutex#synchronize</code>/<code>Thread.new</code> now run single-threaded and carry their " \
                "block's value), the static pre-filter no longer hard-rejects them — they're flagged " \
                "<code>risky</code> (correct for defensive use, degenerate only for true concurrency). Re-probing " \
                "the 8,833 gems that had been rejected on sight for <code>Mutex.new</code>/<code>Thread.new</code>, " \
                "<strong>3,493 (39.5%) moved out of <code>rejected</code></strong> — they compile now; the static " \
                "wall had been hiding it. The four spine gems (<code>bundler</code>/<code>rake</code>/" \
                "<code>minitest</code>/<code>thor</code>) now reject for their <em>real</em> reason — the deep " \
                "metaprogramming surface (<code>send</code>/<code>method_missing</code>/<code>cattr_accessor</code>) — " \
                "not a misleading <code>hard:Mutex.new</code>. The differential re-audit also caught one regression in " \
                "the wave: returning <code>self</code> from a reopened-builtin method " \
                "(<a href=\"https://github.com/matz/spinel/issues/1386\">#1386</a>, <code>to-bool</code>), filed same day." },
        { rev: "b60fbd7", date: "2026-06-15", commit: "636 commits — the largest wave yet. A type-inference + codegen rewrite (typed-array/poly ~222, inference/cast/box ~168, string ~124, block/yield ~101, module/singleton ~94) closing many harness-filed issues at once: reopened-builtin self (#1386), hash-block String type (#1382/#1394), circular require_relative (#1373), computed require (#1383), class-method yield (#1387), Scheduled-server boot + SIGTERM (#1369/#1384). New surfaces: value-type objects, --rbs/--emit-rbs/--emit-symbol-map.",
          file: "survey-b60fbd7/compat.jsonl",
          note: "<strong>The largest movement in the catalog's history.</strong> 636 upstream commits — a type-inference " \
                "rewrite that resolved the entire <code>unresolved:&lt;method&gt;</code> reject family (~60k records → ~0): " \
                "<strong>~49,000 gems moved out of <code>rejected</code></strong> (−46%), +22k to <code>clean</code>. The " \
                "wave also changed unresolvable <code>require</code> to hard-fail the compile (post-#1383); because " \
                "<code>require \"gem/version\"</code> is near-universal that spuriously rejected thousands, so the probe " \
                "now classifies a require-only failure as the no-load-path limit (<code>risky [load-path:require]</code>, " \
                "9,716 gems corrected). Cost side, caught by re-verifying every ★ at this rev: <strong>~34 of 175 " \
                "behaviour-verified gems regressed</strong> (12 miscompiles incl. <code>after_commit_action</code>, 22 " \
                "codegen incl. bare-<code>super</code>/<code>ForwardingSuperNode</code>) — the trust tier dropped 175→136. " \
                "Fresh-verify overrode stickiness, so the ★ count is honest, not carried." },
        { rev: "478cc93", date: "2026-06-16", commit: "46 commits — the b60fbd7 follow-up wave. Every spinelgems-filed bug from b60fbd7 closed + fixed: const-alias receiver #1399 (a5f3044), require-in-conditional #1400 (3b17d67), instance_methods(false) #1401 (6902b50), respond_to? builtins #1408 (89c4832); plus thor proc-return #1372, Float→Integer map #1392 (landed via our PR #1407). New: `...` arg forwarding, instance_exec/eval trampolines, sprintf positional args, Math::DomainError.",
          file: "survey-478cc93/compat.jsonl",
          note: "<strong>The clean-up wave.</strong> matz closed every bug this harness filed in the b60fbd7 " \
                "absorption — within a day, each by a named commit. The headline fix here is <strong>#1400</strong> " \
                "(commit 3b17d67): an unresolvable <code>require</code> reaching codegen is now a runtime no-op, not a " \
                "hard compile failure — so the require-penalty the previous rev had to correct probe-side is gone " \
                "upstream (<code>load-path:require</code> fell 9,716 → 8). Net: <strong>+4,061 gems to <code>clean</code></strong> " \
                "(79.7k → 83.7k), rejected 57.7k → 58.4k roughly flat. ★ 136 → 141 (4 cleanly restored: " \
                "<code>bundler_signature_check</code>, <code>hudson</code>, <code>pry-plus</code>, <code>logger_pipe</code>; " \
                "the rest of the b60fbd7 regressions were load-path-entangled, not the bugs that got fixed). Collaboration " \
                "milestone: our fork PR (<code>fix/array-new-poly-size</code>) merged upstream as the #1392 fix, and matz " \
                "added spinel-dev + spinelgems to the upstream README's community ecosystem." },
        { rev: "f3bb9af9", date: "2026-06-18", commit: "The post-478cc93 codegen + Ractor wave (≈#1413–#1476). Whole-program inference, codegen (poly dispatch, ivar/default-arg typing, loop control-flow, GC rooting of FFI/fresh temps) and a new Ractor API surface (make_shareable, select, RemoteError, introspection). The serve-path regression chain closed (#1420/#1422/#1425/#1434).",
          file: "survey-f3bb9af9/compat.jsonl",
          note: "<strong>A modest, honesty-improving wave for the bulk catalog.</strong> The big codegen movement " \
                "was whole-program (serve/Ractor/training), not the single-gem compile-check this corpus runs — so the " \
                "load-bearing blockers (<code>thor</code>, <code>json</code>, <code>logger</code>, <code>redis</code>, " \
                "<code>rake</code>) did <em>not</em> clear. Net: <strong>+394 gems out of <code>rejected</code></strong> " \
                "(58.4k → 57.9k), +326 <code>clean</code>. The ~32 <code>clean</code>→<code>rejected</code> moves are mostly " \
                "the analyzer getting <em>more honest</em> — refusing cases it previously <strong>silently miscompiled</strong>: " \
                "<code>base26</code>'s <code>each.with_index.inject</code> ran to empty output at 478cc93 and is correctly " \
                "rejected now (filed <a href=\"https://github.com/matz/spinel/issues/1481\">#1481</a>; the broader " \
                "<code>each.with_index</code>-yields-nothing miscompile is <a href=\"https://github.com/matz/spinel/issues/1483\">#1483</a>). " \
                "Re-verified every ★ at this rev: only <strong>1 of 140 regressed</strong> (<code>stringglob</code>, invalid " \
                "generated C under full-surface require), ★ holds at 215 mechanical + human attestations. The require-only " \
                "<code>loaded</code> tier was materialized here for the first time (<strong>0 → 2,311</strong>)." },
        { rev: "f973b129", date: "2026-06-20", commit: "A per-method codegen + diagnostics wave (≈#1499–#1509): method_missing dispatch for unresolved object calls, super into an included-module method, or/and/operator writes, alias under a statement modifier, block_given? in lowered methods, poly arithmetic→bigint (SP_TAG_BIGINT), and new compile-time diagnostics for send/public_send/eval with a runtime (non-constant) name. All three spinelgems issues from the f3bb9af9 reprobe fixed in this window: #1481 (15f4242c), #1483 (d4078d13), #1498 (40871cfe).",
          file: "survey-f973b129/compat.jsonl",
          note: "<strong>Stricter, more honest — driven by new diagnostics, not regressions.</strong> Net: rejected " \
                "<strong>+1,215</strong> (57.9k → 59.1k), risky −1,647, clean +432. The big move is <strong>1,939 " \
                "<code>risky</code>→<code>rejected</code></strong>: the new <code>send</code>/<code>public_send</code> " \
                "diagnostic now refuses a <em>runtime</em> method name (<code>unsupported send with a runtime method name — " \
                "AOT needs a compile-time-known name</code>) instead of silently compiling code that would fail at runtime. " \
                "That's the closed-world limit surfaced honestly: ~2,000 dynamic-dispatch gems can't AOT-compile and are now " \
                "marked so. Genuine fixes also landed — <strong>491 <code>rejected</code>→<code>clean</code></strong> " \
                "(method_missing dispatch, or/and writes, super-into-module). The load-bearing blockers " \
                "(<code>thor</code>/<code>json</code>/<code>logger</code>/<code>redis</code>) still don't clear — their " \
                "failures are deeper (analyze-failed / C-extension). The 55 <code>clean</code>→<code>rejected</code> are the " \
                "same <code>send</code>-diagnostic, not codegen regressions." },
        { rev: "fc2e339a", date: "2026-06-21", commit: "A large promote/poly-dispatch wave (≈#1510–#1515, 104 commits): an experimental full int→poly widen under a <code>g_promote_mode</code> gate with the boxing/unboxing it needs (poly method dispatch, bound-method ABI adapters, op-assign through <code>sp_poly_*</code>), plus standalone codegen: find-pattern matching (<code>in [*head, x, *tail]</code>), <code>case/in</code> in value position, <code>enum_for</code>/<code>to_enum</code> materialization, integer literals wider than int64 kept as bigints, and a frozen-string GC use-after-free fix (fc2e339a). The method_missing dispatch added at f973b129 was reverted (warns instead); a new diagnostic refuses <code>eval</code> in print-argument position.",
          file: "survey-fc2e339a/compat.jsonl",
          note: "<strong>The biggest honest improvement yet for the bulk catalog.</strong> Net: rejected " \
                "<strong>−1,645</strong> (59.1k → 57.5k), risky +1,636, clean +9. The dominant move is <strong>1,639 " \
                "<code>rejected</code>→<code>risky</code></strong>: the promote/poly work plus more complete dispatch " \
                "now <em>compile</em> gems that previously hard-rejected, leaving only a runtime-risk flag. Just <strong>14 " \
                "regressions</strong>, almost all expected — 7 are analyze <em>timeouts</em> on huge generated SDK gems " \
                "(load-induced, not codegen), 3 are the deliberate method_missing-dispatch revert. One genuine codegen " \
                "regression was minimized and filed as <a href=\"https://github.com/matz/spinel/issues/1516\">#1516</a> " \
                "(bitwise <code>&amp;</code> on a bignum receiver — the 64-bit-mask PRNG idiom). The load-bearing blockers " \
                "(<code>thor</code>/<code>json</code>/<code>logger</code>/<code>redis</code>) still don't clear — fourth " \
                "confirmation that the bulk-compile catalog moves only modestly per wave." },
        { rev: "28c173ce", date: "2026-06-27", commit: "249 commits (≈#1569–#1601): a broad Ruby-surface coverage wave (largely ryanseys PRs) — <code>Symbol#to_proc</code>/<code>casecmp</code>, named <code>sprintf</code> references in <code>String#%</code>, Array set-ops + in-place bang mutators (<code>map!</code>/<code>select!</code>/<code>merge!</code>), <code>case/in</code> pattern matching (array/hash/range/find patterns), MatchData named captures, real <code>dup</code>/<code>clone</code> via <code>initialize_copy</code>, <code>Integer#clamp</code>, <code>Float#%</code>, String-array <code>min</code>/<code>max</code>, Regexp introspection, <code>IO#write</code> to STDOUT/STDERR, <code>Mod::X = v</code> constant-path assignment — plus a major analyze-performance line (<a href=\"https://github.com/matz/spinel/issues/1601\">#1601</a>: nodes-by-kind index + O(n²)→indexed scans) and the flatten require-path canonicalization (cbde0f88) that resolves the layout-sensitivity root of <a href=\"https://github.com/matz/spinel/issues/1367\">#1367</a>. Poly-dispatch hardening: drop arms for yielding/DCE-pruned methods (#1583), guard <code>to_s</code>/<code>inspect</code> against the cls_id-0 scalar alias.",
          file: "survey-28c173ce/compat.jsonl",
          note: "<strong>A modest, honest improvement on the bulk catalog.</strong> Net: rejected " \
                "<strong>−239</strong> (57.4k → 57.2k), clean +166, risky +71, verified +3. " \
                "<strong>318 improvements</strong> (219 <code>rejected</code>→<code>clean</code>, 99 " \
                "<code>rejected</code>→<code>risky</code>) outweigh <strong>79 regressions</strong> (51 " \
                "<code>clean</code>→<code>rejected</code>, 28 <code>risky</code>→<code>rejected</code>). Every " \
                "regression is a clean compile-time <em>diagnostic</em>, not a crash: the engine now <em>refuses</em> " \
                "constructs it previously compiled silently — <code>STDOUT.tty?</code>, <code>#merge</code> on a Hash " \
                "constant, <code>#clone</code> on a typed ivar (the new real <code>dup</code>/<code>clone</code> now " \
                "dispatches and rejects shapes it can't type), <code>#encode</code> on a String constant, a proc over an " \
                "uncaptured outer variable. Same stricter-but-honest shape as the f973b129 <code>send</code> diagnostic. " \
                "This wave's headline is structural, not bulk-count: it carries the flatten require-path canonicalization " \
                "(cbde0f88) that closes the layout-sensitivity root of " \
                "<a href=\"https://github.com/matz/spinel/issues/1367\">#1367</a> and the #1601 analyze-performance line. " \
                "The load-bearing blockers (<code>thor</code>/<code>json</code>/<code>logger</code>/<code>redis</code>) " \
                "still don't clear — fifth confirmation the bulk catalog moves only modestly per wave." },
        { rev: "42adf886", date: "2026-07-06", commit: "291 commits (≈#1601–#1746): the <a href=\"https://github.com/matz/spinel/issues/1605\">#1605</a> regression burndown (matz + ryanseys) — <code>IO</code> methods on <code>STDOUT</code>/<code>STDERR</code> modelled (<code>tty?</code>/<code>&lt;&lt;</code>/<code>fileno</code>/<code>winsize</code>, 2d7dbb09), <code>#clone</code> via <code>initialize_copy</code> super (feefc370), <code>Hash#merge</code>/<code>SplatNode</code>/<code>EmbeddedStatementsNode</code> interpolation (#1610/#1612/#1611), the <code>Enumerator.new</code> outer-variable proc shape, <code>Array#sort_by!</code> (d06867f7), and <code>module Encoding</code> collisions now reporting CRuby's <code>TypeError</code> at compile time (1dc427ef). Plus the opt-in never-more-permissive-than-CRuby gates — <code>SPINEL_REQUIRE_GATE</code> (over-provided stdlib now needs its <code>require</code>) and <code>SPINEL_GATE_RAISE</code> (the NoMethodError silent-default gate), both <em>default-off</em>. Ecosystem: matz shipped <a href=\"https://github.com/matz/spinel/blob/main/docs/spin.md\"><code>spin</code></a> + <a href=\"https://github.com/matz/spin-index\">spin-index</a>, superseding the #925 Gemfile RFC.",
          file: "survey-42adf886/compat.jsonl",
          note: "<strong>Stricter, and more honest.</strong> Net: rejected <strong>+962</strong> (57.2k → 58.2k), " \
                "clean −957, verified held at <strong>231</strong>. <strong>1,909 improvements</strong> outweighed " \
                "by <strong>2,873 regressions</strong> (1,786 <code>clean</code>→<code>rejected</code>, 1,086 " \
                "<code>risky</code>→<code>rejected</code>) — but every regression sampled is a clean compile-time " \
                "<em>refusal</em>, <strong>not a crash</strong> (0 segfaults in a 69-gem sample; all exit-1 " \
                "<code>unsupported call</code> diagnostics). It is the <a href=\"https://github.com/matz/spinel/issues/1605\">#1605</a> " \
                "silent-wrong→loud-refuse campaign at corpus scale: the engine now refuses calls on unresolved-type " \
                "receivers and gems leaning on stdlib Spinel doesn't provide (<code>uri</code>, <code>csv</code>, " \
                "<code>socket</code>, …), where before it compiled a silent typed-default that would fail at runtime. " \
                "The top-line moves backward; compatibility <em>honesty</em> moves forward. Reframed this cycle around " \
                "<code>spin</code>: the catalog is now the compatibility oracle and the intended seed for spin-index." },
        { rev: "12b757f0", date: "2026-07-22",
          commit: "981 commits (≈#3148–#3227): the poly-dispatch / inference hardening wave — user-defined operators " \
                  "(<code>&lt;=&gt;</code> subclass operands, <code>&lt;&lt;</code>, <code>==</code> honored in " \
                  "<code>Array#include?</code>, user binops on boxed operands), keyword params no longer bound by " \
                  "position in poly dispatch, destructuring typing, Data/Struct members shadowing builtins, threads " \
                  "(per-worker string + young-object heaps), <code>IO.copy_stream</code>, shared-mutable strings " \
                  "phase 1 (#3227), and <code>spin test</code> incremental cache + parallel builds (#3202).",
          file: "survey-12b757f0/compat.jsonl",
          note: "<strong>The biggest verified jump yet: ★320 (+89).</strong> The inference wave lands at harness " \
                "scale — 192 gems earned a first-time mechanical ★, 127 re-earned, 16 lost (13 behaviour " \
                "build-errors under triage). Pure movement: <strong>2,814 improvements</strong> (1,827 " \
                "<code>rejected</code>→<code>clean</code>) vs <strong>5,425 regressions</strong> — but 5,418 of those " \
                "are ONE cluster: the pre-bundler <code>$:.unshift File.dirname(__FILE__)</code> preamble now " \
                "hard-fails analysis where the old engine compiled it into a runtime line-1 bomb " \
                "(<code>undefined method 'unshift'</code>). Same stricter-honest shape as #1605: those gems were " \
                "never actually runnable; now the refusal is loud and at compile time. Net: rejected " \
                "<strong>+3,238</strong>, clean −1,072, risky −1,811. Buildable 83,957 (−2,545)." },
        { rev: "76cfd099", date: "2026-07-24",
          commit: "126 commits (≈#3234–#3293): 10108a62 — <strong>our <a href=\"https://github.com/matz/spinel/issues/3284\">#3284</a> " \
                  "design ask implemented</strong>: load-path manipulation in statement position warns and no-ops, the " \
                  "ignored-require symmetry. Plus 68fd45da (namespace-qualified <code>is_a?</code>, our " \
                  "<a href=\"https://github.com/matz/spinel/issues/3258\">#3258</a>), the " \
                  "<a href=\"https://github.com/matz/spinel/issues/3259\">#3259</a> builtin-shadow dispatch fix, " \
                  "always-frozen string literals (91f069f0), <code>Forwardable</code> delegators, and lazy-enumerator " \
                  "composition work.",
          file: "survey-76cfd099/compat.jsonl",
          note: "<strong>The first strongly-positive cycle: 2,379 improvements vs 141 regressions.</strong> " \
                "The <code>$:</code>-preamble cluster flipped back exactly as projected in #3284 — <strong>2,309 " \
                "gems recovered</strong> (976 <code>rejected</code>→<code>clean</code>, 1,403 " \
                "<code>rejected</code>→<code>risky</code>). Net: rejected <strong>−2,236</strong>, clean +907, " \
                "risky +1,327, ★ held at <strong>320</strong>. Buildable 85,629 (+1,672). The filed→fixed→measured " \
                "loop closed in 48 hours: this cycle's headline movement IS the previous cycle's bug report. " \
                "The few true regressions include always-frozen literals biting literal-mutating gems " \
                "(91f069f0, deliberate upstream semantics) and one new miscompile pair under triage." },
        { rev: "c51b0a1c", date: "2026-07-26",
          commit: "102 commits (681b08ae + c51b0a1c windows): same-day fixes for our " \
                  "<a href=\"https://github.com/matz/spinel/issues/3320\">#3320</a>/" \
                  "<a href=\"https://github.com/matz/spinel/issues/3321\">#3321</a>/" \
                  "<a href=\"https://github.com/matz/spinel/issues/3322\">#3322</a> (13ab61b1 <code>defined?(::X)</code> " \
                  "anchor, 79fdd68e builtin-<code>Dir</code> reopen, hash-variant keys), a bundled <code>pathname</code> " \
                  "(1f747d86), require-gated <code>Monitor</code>, reader-over-String-method dispatch (5a2127b6), " \
                  "and a broad regex/poly hardening line.",
          file: "survey-c51b0a1c/compat.jsonl",
          note: "<strong>Second consecutive positive cycle, and the first with ZERO ★ attrition:</strong> all 322 " \
                "prior ★ re-earned, <strong>★337</strong> (+15 — the #3320/#3321/#3322 triage gems return, plus " \
                "spinel_kit now verifying natively in spin package shape). <strong>925 improvements vs 73 " \
                "regressions</strong>; rejected <strong>−868</strong>. Buildable 86,393 (+764). Also the first " \
                "fully-clean sweep: no wedged shards, no lost probes — the UTF-8 scrub, static-scan budget, and " \
                "spin-shape probing all holding." },
        { rev: "c51b0a1c-refresh", date: "2026-07-27",
          commit: "Network REFRESH (not a reprobe): the first full re-fetch since before the spin pivot — " \
                  "195.5k names off the Compact Index, latest-version resolution + fetch for every gem whose " \
                  "cached version had moved, all probed at engine c51b0a1c. Corpus grows 189,752 → 192,021.",
          file: "survey-refresh-0727/compat.jsonl",
          note: "<strong>The corpus caught up with the ecosystem.</strong> 2,278 never-probed gems entered " \
                "(clean 946 · risky 315 · rejected 1,017 — but ~half the rejects are empty <code>no-entrypoint</code> " \
                "name placeholders; among new gems that ship real code, ~54% are clean — the post-pivot generation " \
                "skews friendlier to the subset). First-ever version-bump signal: 163 gems changed verdict purely " \
                "from a newer release, <strong>60 up vs 103 down</strong> — ecosystem churn slightly outpaces " \
                "subset-friendliness at the margin. Canonical ★337 · loaded 1,850 · clean 82,233 · risky 48,270 · " \
                "rejected 59,331. Dependency graph rebuilt (239,803 → 278,807 edges); buildable 87,342." },
        { rev: "55638986", date: "2026-08-25",
          commit: "285 commits (c51b0a1c → 55638986): the <strong>bundled-stdlib require-gate</strong> maturing — " \
                  "<code>digest</code>/<code>json</code>/<code>erb</code>/<code>csv</code> are bundled packages that " \
                  "must be explicitly <code>require</code>d (489cbde7 \"a bundled library carries only what it uses\"), " \
                  "so a program that uses <code>Digest</code> without <code>require \"digest\"</code> now fails to " \
                  "compile — matching CRuby's documented interface. Plus a broad poly-String / regexp-byte-fidelity / " \
                  "empty-literal inference line, and our own <a href=\"https://github.com/matz/spinel/issues/3976\">#3976</a> " \
                  "undefined-constant compile-time warning landing.",
          file: "survey-55638986/compat.jsonl",
          note: "<strong>Stricter, and more honest — again.</strong> ★ moves <em>up</em> to <strong>372</strong> " \
                "(+35, the inference wave lifting the verified tier), while the top line moves back: rejected " \
                "<strong>+2,073</strong> (59,331 → 61,404). 2,649 improvements (1,504 <code>rejected</code>→" \
                "<code>clean</code>) vs 4,813 regressions, the latter dominated by the require-gate — gems that " \
                "leaned on <code>Digest</code>/<code>JSON</code>/<code>ERB</code> being implicitly available now " \
                "refuse at compile time, exactly as CRuby's interface says they should. No crashes; every sampled " \
                "regression is a clean compile-time refusal naming the missing <code>require</code>. Buildable " \
                "86,149. Same silent-wrong→loud-refuse shape as the #1605 wave and the <code>$:</code> preamble." },
        { rev: "112bae85", date: "2026-09-14",
          commit: "806 commits (55638986 → 112bae85), and the first <strong>dated release</strong>: " \
                  "<a href=\"https://github.com/matz/spinel/releases/tag/2026.09.12\"><code>2026.09.12</code></a>. " \
                  "A consolidation wave rather than a subset one — <code>Thread</code> becomes a true " \
                  "<strong>M:N runtime with no GVL</strong> (N OS workers, real " \
                  "<code>Mutex</code>/<code>Queue</code>/<code>ConditionVariable</code>, ~10ms preemption), the " \
                  "generational object mark becomes the default, and seven bundled packages arrive " \
                  "(<code>net/http</code>, <code>uri</code>, <code>openssl</code>, <code>fileutils</code>, " \
                  "<code>tmpdir</code>, <code>zlib</code>, <code>securerandom</code>). Plus <code>spin flags</code> " \
                  "for builds driven from outside spin, declared carried-C (<code>[package] sources</code>), and " \
                  "<code>promise_diff</code> — a release now says what it promises and what changed.",
          file: "survey-112bae85/compat.jsonl",
          note: "<strong>The quietest cycle the catalog has recorded — and the biggest correction came from " \
                "our own probe.</strong> The compiler moved barely at all: of 192,027 gems common to both revs " \
                "only <strong>1,400 changed verdict (0.7%)</strong>, 882 improvements against 518 regressions. " \
                "Eight hundred commits and seven new bundled packages left the blocker histogram almost " \
                "unchanged — which is what a consolidation release looks like from here. " \
                "Then the release invalidated one of our own assumptions: the probe still flagged every " \
                "<code>Thread.new</code> / <code>Mutex.new</code> as risky, on a premise from " \
                "<a href=\"https://github.com/matz/spinel/issues/1360\">#1360</a> that they ran " \
                "single-threaded and were &ldquo;degenerate for genuine concurrency&rdquo;. Verified here against " \
                "CRuby: 8 threads summing through a <code>Mutex</code> plus a <code>Queue</code> " \
                "producer/consumer are byte-identical, and 4 threads each sleeping 1s join in " \
                "<strong>under 2s</strong> — a single-threaded lowering takes 4. The flag was retired, and " \
                "<strong>2,492 gems</strong> whose only blocker it was became <code>clean</code>. " \
                "Canonical ★394 · loaded 1,838 · clean 83,815 · risky 44,964 · rejected 61,027. " \
                "Split honestly: the compiler is worth <strong>rejected −377</strong> and ★ +22; the " \
                "classifier correction is worth <strong>clean +2,449</strong> against risky. Buildable 86,676 " \
                "(+527; edges unchanged — cache-only reprobe)." },
      ].freeze

      ORDER = %w[clean risky rejected].freeze

      def initialize(base = ".")
        @base = base
      end

      # Render the full history page to `out`.
      def build_html(out)
        runs = RUNS.map { |r| r.merge(tally: tally(File.join(@base, r[:file]))) }
                  .select { |r| r[:tally] }
        body = +""
        body << "<h1>How the catalog has changed</h1>\n"
        body << %(<p class="lede">Each row is a full re-probe of the ~190k-gem corpus at one )
        body << %(<a href="https://github.com/matz/spinel">Spinel</a> revision. The harness's )
        body << %(real product is a stream of focused compiler bugs; this is the loop closing — )
        body << %(fixes landing upstream, gems graduating out of <code>rejected</code>.</p>\n)

        body << timeline_table(runs)
        runs.each_cons(2) { |a, b| body << delta_card(a, b) }

        File.write(out, page("History — SpinelGems", body))
        out
      end

      private

      def tally(path)
        return nil unless File.exist?(path)
        h = Hash.new(0)
        File.foreach(path) { |l| v = (JSON.parse(l)["verdict"] rescue nil); h[v] += 1 if v }
        h
      end

      def timeline_table(runs)
        s = +%(<table class="timeline"><thead><tr><th>engine rev</th><th>date</th>)
        ORDER.each { |k| s << %(<th class="num">#{glyph(k)} #{k}</th>) }
        s << %(<th>what landed</th></tr></thead><tbody>\n)
        prev = nil
        runs.each do |r|
          s << %(<tr><td class="g"><code>#{h r[:rev]}</code></td><td class="upd">#{h r[:date]}</td>)
          ORDER.each do |k|
            d = prev ? (r[:tally][k] - prev[:tally][k]) : nil
            s << %(<td class="num">#{fmt(r[:tally][k])}#{delta_span(d)}</td>)
          end
          s << %(<td class="desc">#{r[:commit]}</td></tr>\n)
          prev = r
        end
        s << "</tbody></table>\n"
        s
      end

      def delta_card(a, b)
        return "" unless b[:note]
        moved = transitions(File.join(@base, a[:file]), File.join(@base, b[:file]))
        grad = moved.select { |k, _| k.end_with?("->clean") || k.end_with?("->risky") }.sum { |_, v| v }
        regr = moved.select { |k, _| k.end_with?("->rejected") && !k.start_with?("rejected") }.sum { |_, v| v }
        top = moved.sort_by { |_, v| -v }.first(5)
        s = +%(<div class="delta-card"><h3><code>#{h a[:rev]}</code> &rarr; <code>#{h b[:rev]}</code> )
        s << %(<span class="up">&uarr; #{fmt grad} graduated</span> )
        s << %(<span class="down">&darr; #{fmt regr} regressed</span></h3>\n)
        s << %(<p>#{b[:note]}</p>\n)
        s << %(<p class="meta">Top transitions: ) << top.map { |k, v| "#{h k} <b>#{fmt v}</b>" }.join(" &middot; ") << "</p>\n"
        s << "</div>\n"
        s
      end

      def transitions(old_file, new_file)
        old = {}
        File.foreach(old_file) { |l| r = JSON.parse(l) rescue next; old[r["gem"]] = r["verdict"] }
        t = Hash.new(0)
        File.foreach(new_file) do |l|
          r = JSON.parse(l) rescue next
          o = old[r["gem"]]
          t["#{o}->#{r["verdict"]}"] += 1 if o && o != r["verdict"]
        end
        t
      end

      def delta_span(d)
        return "" if d.nil? || d.zero?
        cls = d.positive? ? "up" : "down"
        %( <span class="#{cls}">#{d.positive? ? "+" : ""}#{fmt d}</span>)
      end

      def glyph(v)
        { "clean" => "✓", "risky" => "~", "rejected" => "✗", "verified" => "★", "loaded" => "○" }[v] || "?"
      end

      def fmt(n)
        a = n.abs
        s = a >= 1000 ? "#{(a / 1000.0).round(1)}k" : a.to_s
        n.negative? ? "−#{s}" : s
      end

      def h(s) = CGI.escapeHTML(s.to_s)

      def page(title, body)
        gem = %(<svg class="gem" viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h12l4 6-10 13L2 9z" fill="#7b2d8e"/><path d="M6 3 2 9l10 13z" fill="#5a1f6b" opacity=".55"/><path d="M18 3l4 6-10 13z" fill="#b14fc4"/><path d="M6 3h12l-6 6z" fill="#d98ee8"/></svg>)
        <<~HTML
          <!doctype html>
          <html lang="en"><head><meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>#{h title}</title><link rel="stylesheet" href="/assets/style.css"></head>
          <body>
          <header><a class="brand" href="/">#{gem}SpinelGems</a>
            <nav><a href="/">Home</a> <a href="/catalog">Catalog</a> <a href="/load-bearing.html">Load-bearing</a> <a href="/history.html">History</a>
              <a href="https://github.com/OriPekelman/spinelgems">GitHub</a></nav></header>
          <main>
          #{body}
          </main>
          #{Site::FOOTER_HTML}
          </body></html>
        HTML
      end
    end
  end
end
