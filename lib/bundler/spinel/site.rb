require "fileutils"
require "cgi"
require "json"
require "set"

module Bundler
  module Spinel
    # Builds the static spinelgems.org deploy tree — the *apex double-duty*
    # layout, where one directory served by one static host is both a human
    # website and a machine RubyGems source:
    #
    #   out/index.html             presentation (copied from the repo's site/ dir)
    #   out/catalog.html           landing: verdict-mix chips + per-verdict links
    #   out/catalog-<verdict>.html one page per verdict (split for browser perf —
    #                              one 90MB HTML was painful, even on a fast box)
    #   out/assets/…               shared CSS
    #   out/versions  out/names  out/info/<gem>  out/gems/<file>.gem
    #                              the Compact Index (only when a --store is given)
    #
    # The reserved Compact Index paths and the human paths don't collide, so
    # `source "https://spinelgems.org"` in a Gemfile resolves against the curated
    # source while a browser at the same origin gets the site. The catalog is the
    # human-readable view of the *same* ledger the gate and the curated source
    # are built on, joined with rubygems.org metadata (a meta.jsonl sidecar). It
    # renders offline from committed data — no Spinel, no network — so it builds
    # on the deploy host; the engine rev is read from the ledger, not probed.
    class Site
      SRC = File.expand_path("../../../site", __dir__) # the repo's site/ source dir

      VERDICT_ORDER = %w[verified loaded clean risky rejected].freeze
      GLYPH = { "verified" => "★", "loaded" => "○", "clean" => "✓", "risky" => "~", "rejected" => "✗" }.freeze

      # Verdict ladder by strength. Used to pick the strongest current-rev signal
      # for a gem when multiple probes wrote different verdicts (the survey
      # writes clean, an earlier harness pass at the same rev wrote loaded; the
      # harness *ran* something the survey didn't, so it wins). Rejected is
      # handled separately by `pick_current` — a caught failure beats any
      # success-shaped signal regardless of where it ranks here.
      VERDICT_RANK = { "rejected" => 0, "risky" => 1, "clean" => 2, "loaded" => 3, "verified" => 4 }.freeze

      # Default downloads floor for the catalog's "hide low-signal gems" toggle —
      # weeds out test / security-researcher / throwaway gems (the exfil PoC has
      # ~580 downloads; rake has ~1.3B). Tunable via SPINEL_CATALOG_MIN_DOWNLOADS.
      MIN_DOWNLOADS = Integer(ENV.fetch("SPINEL_CATALOG_MIN_DOWNLOADS", "1000"))

      # Cap on the rejected page (~113k full would be ~50MB of HTML — still slow
      # to load even split out). Top-N by downloads keeps the *signal* — popular
      # gems we want and can't yet have — and drops the long tail of obscure
      # rejects, which is just noise for browsing. The complete machine-readable
      # list stays in compat.jsonl / candidates.tsv for anyone who needs it.
      REJECTED_CAP = Integer(ENV.fetch("SPINEL_CATALOG_REJECTED_CAP", "2000"))

      # One-line semantics per verdict — used as the lede on each per-verdict page.
      BLURB = {
        "verified" => "<strong>Full surface</strong> compiles and a behaviour smoke matches CRuby under a Spinel-compiled harness — every <code>lib/</code> file force-required (no <code>autoload</code> masking, no missing-dependency rescue), not just the entrypoint. The only verdict to trust where it matters. A constant/VERSION-only smoke that loads the entrypoint but leaves the gem's real code behind <code>autoload</code> is <em>not</em> enough — that overstated usability, so the bar was tightened to whole-surface. Sticky across engine revisions until a re-run catches a regression.",
        "loaded"   => "Compiles and loads identically under CRuby and Spinel via a require-only differential. Logic untested — a gem can load fine and still silently miscompile in the code paths the require-only smoke doesn't exercise. Weaker than <strong>verified</strong>; not a trust signal.",
        "clean"    => "Compiles clean (cheap static lower bound). No behaviour was exercised — the survey doesn't run the gem. Massively overstates compatibility; the harness is the trustworthy check.",
        "risky"    => "Compiles, but the source uses constructs Spinel degrades silently (<code>eval</code>, <code>define_method</code>, …). Allowed by default; fails under <code>spinel-compat check --strict</code>.",
        "rejected" => "Doesn't compile, or compiles to silent no-ops we detected — including <code>rejected:miscompile</code> caught by the harness. Each reason names the missing feature; the histogram is the prioritized roadmap of Spinel asks."
      }.freeze

      Row = Struct.new(:gem, :version, :verdict, :notes, :downloads, :info,
                       :updated, :homepage, keyword_init: true)

      def initialize(ledger: Ledger.new, engine: nil, src: SRC, meta_path: nil)
        @ledger = ledger
        @engine = engine
        @src = src
        @meta_path = meta_path
      end

      # out: deploy dir. store: optional dir of vetted .gem files → Compact Index.
      def build(out, store: nil, min_verdict: :verified)
        FileUtils.mkdir_p(out)
        copy_presentation(out)

        rs = rows
        counts = Hash.new(0)
        rs.each { |r| counts[r.verdict] += 1 }

        File.write(File.join(out, "catalog.html"), catalog_landing_html(rs, counts))
        VERDICT_ORDER.each do |v|
          File.write(File.join(out, "catalog-#{v}.html"), verdict_page_html(v, rs, counts))
        end

        compact_index(out, store, min_verdict) if store
        out
      end

      # Materialize the catalog into a SQLite DB for the dynamic (Tep) server:
      # one row per gem, with `rows`' stickiness already applied, so the runtime
      # only does indexed SELECTs (no 209k-line ledger replay per request, no
      # 90MB-HTML split, no REJECTED_CAP). Built at deploy and served read-only.
      #
      # We shell out to the `sqlite3` CLI (TSV `.import`) rather than the Ruby
      # sqlite3 gem: no native-gem build at deploy, and the file is read by
      # Tep::SQLite (C) at runtime — same on-disk format. `rows` stays the single
      # source of verdict truth.
      def build_db(db_path)
        require "open3"
        require "tempfile"
        require "time"

        rs = rows
        # Strip control chars incl. the ASCII unit/record separators (\x1c-\x1f)
        # we use as the .import delimiters, so no field value can break a row.
        clean = ->(s) { s.to_s.gsub(/[\t\r\n\x1c-\x1f]+/, " ").strip }
        us = "\x1f" # unit (field) separator
        rs_ = "\x1e" # record separator
        tsv = Tempfile.new(["catalog", ".asv"])
        begin
          rs.each do |r|
            tsv.write([r.gem, r.gem.downcase, clean.(r.version), r.verdict,
                       r.downloads.to_i, clean.(r.info), clean.(r.updated),
                       clean.(r.homepage), clean.(r.notes)].join(us) + rs_)
          end
          tsv.flush
          FileUtils.rm_f(db_path)
          # .mode ascii uses \x1f/\x1e separators with NO quote processing —
          # robust for arbitrary description text (.mode tabs/csv quote-swallows
          # rows whose info contains a `"`, silently dropping ~10% of gems).
          sql = <<~SQL
            PRAGMA journal_mode=OFF;
            CREATE TABLE catalog (
              gem TEXT PRIMARY KEY, gem_lower TEXT NOT NULL, version TEXT,
              verdict TEXT NOT NULL, downloads INTEGER NOT NULL DEFAULT 0,
              info TEXT, updated TEXT, homepage TEXT, notes TEXT
            );
            .mode ascii
            .import #{tsv.path} catalog
            CREATE INDEX idx_verdict_dl ON catalog(verdict, downloads DESC);
            CREATE INDEX idx_downloads  ON catalog(downloads DESC);
            CREATE INDEX idx_gem_lower  ON catalog(gem_lower);
            CREATE TABLE catalog_meta (key TEXT PRIMARY KEY, value TEXT);
            INSERT INTO catalog_meta VALUES
              ('rev', #{sql_str(rev)}),
              ('total', '#{rs.size}'),
              ('built_at', '#{Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")}');
          SQL
          out, st = Open3.capture2e("sqlite3", db_path, stdin_data: sql)
          raise Error, "sqlite3 build failed: #{out}" unless st.success?
        ensure
          tsv.close!
        end
        db_path
      end

      private

      def sql_str(s) = "'#{s.to_s.gsub("'", "''")}'"

      def copy_presentation(out)
        return unless File.directory?(@src)

        # README.md documents the source dir; it isn't a deploy artifact.
        Dir.children(@src).reject { |c| c =~ /\AREADME/i }.each do |c|
          FileUtils.cp_r(File.join(@src, c), out)
        end
      end

      def compact_index(out, store, min)
        require_relative "proxy"
        Proxy.new(store: File.expand_path(store), ledger: @ledger,
                  engine: @engine || Engine.new, min_verdict: min).write_static(out)
      end

      # --- catalog (the ledger + rubygems metadata, for humans) -------------

      # The engine rev this snapshot is for — the dominant rev in the ledger, so
      # the site builds with no live Spinel (e.g. on the deploy host).
      def rev
        @rev ||= begin
          tally = Hash.new(0)
          @ledger.each { |v| tally[v.rev] += 1 }
          tally.max_by { |_, c| c }&.first || "(no verdicts)"
        end
      end

      # gem => metadata hash, from the meta.jsonl sidecar (may be absent).
      def meta
        @meta ||= begin
          m = {}
          if @meta_path && File.exist?(@meta_path)
            File.foreach(@meta_path) do |line|
              line = line.strip
              next if line.empty?

              begin
                h = JSON.parse(line)
              rescue JSON::ParserError
                next
              end
              m[h["gem"]] = h
            end
          end
          m
        end
      end

      # Latest verdict per gem at this rev, joined with metadata, popularity-ranked.
      #
      # Two symmetric stickiness rules — both rooted in the principle that a
      # *behavioural* signal (verified, rejected:miscompile) outranks a static
      # one (clean, risky) regardless of probe order:
      #
      # - **Sticky-verified.** A (gem, version) that earned `verified` at *any*
      #   rev carries that verdict forward. Re-running the harness for every
      #   rev is costly and we trust an honest behaviour-smoke match across
      #   compiler revisions until we explicitly re-verify.
      #
      # - **Sticky-rejected (current-rev).** Among current-rev entries for the
      #   same gem, a `rejected` (compile error or harness-caught miscompile)
      #   wins over any softer verdict like `clean` or `loaded`. The survey
      #   only catches compile-time failures; the harness can catch a silent
      #   miscompile that the survey can't see. When both have spoken, we
      #   honour the worse news.
      #
      # Together: a current-rev `rejected` defeats the historical `verified`
      # (we treat caught regressions as fact), and a current-rev `verified`
      # tops a clean/loaded with the same key.
      def rows
        target_rev = rev
        ever_verified = Set.new
        current_entries = Hash.new { |h, k| h[k] = [] }
        @ledger.each do |v|
          # `verified` is now the *full-surface* bar: only a `verify-full` probe
          # (force-requires every lib file, no dependency masking — the smoke
          # matched AND the whole gem compiled+loaded) earns the ★. An
          # entrypoint-only `verify` that matched a constant/VERSION smoke while
          # the gem's real surface stayed behind autoload/plain-require does NOT
          # count — it overstated usability (the qdrant-ruby spike, spinelgems#4).
          ever_verified << [v.gem, v.version] if v.verdict == "verified" && v.probe == "verify-full"
          current_entries[v.gem] << v if v.rev == target_rev
        end

        current_entries.map do |name, vs|
          # Within the current rev, pick the *strongest* signal — not the
          # most recent. A rejected (compile error or harness miscompile)
          # always wins (caught failures are facts); otherwise pick the
          # highest-ranked verdict by VERDICT_RANK, so loaded > clean and a
          # past harness run isn't overshadowed by a subsequent survey clean.
          v = vs.find { |x| x.verdict == "rejected" } ||
              vs.max_by { |x| VERDICT_RANK[x.verdict] || -1 }
          md = meta[name] || {}
          eff_verdict = if v.verdict == "rejected"
                          "rejected"
                        elsif ever_verified.include?([name, v.version])
                          "verified"
                        else
                          v.verdict
                        end
          Row.new(gem: name, version: v.version, verdict: eff_verdict,
                  notes: (v.reasons + v.risks).first(8).join(", "),
                  downloads: md["downloads"].to_i, info: md["info"],
                  updated: md["updated"], homepage: md["homepage"])
        end.sort_by { |r| [-r.downloads, r.gem.downcase] }
      end

      # Landing: a short lede + the verdict-mix chips, each linking to its own
      # per-verdict page. No big table here — that's the whole point of the
      # split. A user lands, sees the breakdown, clicks the tier they care
      # about, and only pays the cost of that tier.
      def catalog_landing_html(rs, counts)
        body = +""
        body << %(<p class="lede">Compatibility ledger as of <code>#{h rev}</code> — )
        body << %(<strong>#{fmt_n rs.size}</strong> gems surveyed, ranked by downloads in each tier. )
        body << %(Trust <strong>★ verified</strong> (a behaviour smoke matched CRuby), not )
        body << %(<strong>✓ clean</strong> (a cheap lower bound) or <strong>○ loaded</strong> )
        body << %((require-only differential — logic untested, can still silently miscompile). )
        body << %(Verdicts are forward-compatible: keyed on the Spinel revision, a gem rejected )
        body << %(today clears the moment the feature it needs lands.</p>\n)

        body << %(<div class="filters">\n)
        VERDICT_ORDER.each do |v|
          body << %(  <a href="catalog-#{v}.html" class="chip #{v} on">#{GLYPH[v]} #{v} <span>#{fmt_n counts[v]}</span></a>\n)
        end
        body << %(</div>\n)

        body << %(<p class="meta">Raw data: <a href="https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/compat.jsonl">compat.jsonl</a> · )
        body << %(<a href="https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/candidates.tsv">candidates.tsv</a> · )
        body << %(<a href="https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/report.md">report.md</a>)
        body << %(</p>\n)

        page("Catalog — SpinelGems", body)
      end

      # One verdict's rows, with search + downloads-floor controls. Same shape
      # as the old all-in-one catalog, just sliced. Rejected is capped at
      # REJECTED_CAP popular gems (the long tail of obscure rejects is in
      # candidates.tsv / compat.jsonl for machine consumers).
      def verdict_page_html(verdict, all_rs, counts)
        full = all_rs.select { |r| r.verdict == verdict }
        capped = (verdict == "rejected") && full.size > REJECTED_CAP
        shown = capped ? full.first(REJECTED_CAP) : full

        body = +""
        body << %(<p class="chip-strip">)
        VERDICT_ORDER.each do |v|
          klass = v == verdict ? "chip #{v} on" : "chip #{v}"
          body << %(<a href="catalog-#{v}.html" class="#{klass}">#{GLYPH[v]} #{v} <span>#{fmt_n counts[v]}</span></a> )
        end
        body << %(</p>\n)

        body << %(<h2>#{GLYPH[verdict]} #{verdict} <span class="muted">— #{fmt_n shown.size}#{capped ? " of #{fmt_n full.size}" : ""} gems</span></h2>\n)
        body << %(<p class="lede">#{BLURB[verdict]}</p>\n)
        if capped
          body << %(<p class="cap-note">Showing the top <strong>#{fmt_n REJECTED_CAP}</strong> rejected gems by downloads — the long-tail of obscure rejects is noise for browsing. )
          body << %(Complete list in <a href="https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/compat.jsonl">compat.jsonl</a> )
          body << %((or <a href="https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/candidates.tsv">candidates.tsv</a> for the aggregate roadmap signal).</p>\n)
        end

        body << %(<div class="filters">\n)
        body << %(  <input id="q" type="search" placeholder="filter by gem name…" autocomplete="off">\n)
        body << %(  <label class="floor"><input type="checkbox" id="floor" checked> )
        body << %(hide low-signal gems (&lt; #{fmt_n MIN_DOWNLOADS} downloads)</label>\n)
        body << %(</div>\n)

        body << %(<table id="catalog"><thead><tr><th>verdict</th><th>gem</th>)
        body << %(<th class="num">downloads</th><th>updated</th><th>description</th></tr></thead><tbody>\n)
        shown.each do |r|
          gem_cell = r.homepage ? %(<a href="#{h r.homepage}" rel="noopener nofollow">#{h r.gem}</a>) : h(r.gem)
          body << %(<tr data-gem="#{h r.gem.downcase}" data-dl="#{r.downloads}">)
          body << %(<td class="v #{r.verdict}" title="#{h r.notes}">#{GLYPH[r.verdict]} #{r.verdict}</td>)
          body << %(<td class="g">#{gem_cell} <span class="ver">#{h r.version}</span></td>)
          body << %(<td class="num">#{fmt_n r.downloads}</td>)
          body << %(<td class="upd">#{fmt_date r.updated}</td>)
          body << %(<td class="desc">#{h truncate(r.info, 140)}</td></tr>\n)
        end
        body << "</tbody></table>\n"

        page("#{verdict.capitalize} gems — SpinelGems", body, script: verdict_page_js)
      end

      # Minimal page chrome shared with the hand-written landing (same CSS).
      def page(title, body, script: nil)
        <<~HTML
          <!doctype html>
          <html lang="en">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>#{h title}</title>
            <link rel="stylesheet" href="assets/style.css">
          </head>
          <body>
          <header><a class="brand" href="./">SpinelGems</a>
            <nav><a href="./">Home</a> <a href="catalog.html">Catalog</a>
              <a href="https://github.com/OriPekelman/spinelgems">GitHub</a></nav>
          </header>
          <main>
          <h1>Spinel-compatible gems</h1>
          #{body}
          </main>
          <footer>Pre-release · verdicts keyed on the Spinel engine revision ·
            Hosted on <a href="https://upsun.com" rel="noopener">Upsun</a> ·
            Built with <a href="https://github.com/OriPekelman/tep" rel="noopener">Tep</a>
            (compiled by Spinel) · <a href="./">spinelgems.org</a></footer>
          #{script ? "<script>#{script}</script>" : ''}
          </body>
          </html>
        HTML
      end

      def h(s) = CGI.escapeHTML(s.to_s)

      def truncate(str, n)
        s = str.to_s.gsub(/\s+/, " ").strip
        s.length > n ? "#{s[0, n - 1]}…" : s
      end

      # Compact download counts: 1326859499 -> "1.3B", 342000 -> "342.0k".
      def fmt_n(num)
        n = num.to_i
        return n.to_s            if n < 1_000
        return "#{(n / 1e3).round(1)}k" if n < 1_000_000
        return "#{(n / 1e6).round(1)}M" if n < 1_000_000_000
        "#{(n / 1e9).round(1)}B"
      end

      def fmt_date(s) = s.to_s[0, 10] # YYYY-MM-DD

      # Per-verdict pages: just search + downloads-floor filter (no chip filter,
      # since each page is a single verdict). Smaller JS than the old all-in-one.
      def verdict_page_js
        "const FLOOR = #{MIN_DOWNLOADS};\n" + VERDICT_PAGE_JS
      end

      VERDICT_PAGE_JS = <<~'JS'
        const q = document.getElementById('q');
        const floor = document.getElementById('floor');
        const rows = [...document.querySelectorAll('#catalog tbody tr')];
        function apply() {
          const term = q.value.trim().toLowerCase();
          const hideLow = floor.checked;
          for (const tr of rows) {
            const okQ = !term || tr.dataset.gem.includes(term);
            const okF = !hideLow || (+tr.dataset.dl) >= FLOOR;
            tr.style.display = (okQ && okF) ? '' : 'none';
          }
        }
        q.addEventListener('input', apply);
        floor.addEventListener('change', apply);
        apply();
      JS
    end
  end
end
