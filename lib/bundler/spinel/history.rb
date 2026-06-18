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
