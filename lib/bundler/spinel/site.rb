require "fileutils"
require "cgi"
require "json"

module Bundler
  module Spinel
    # Builds the static spinelgems.org deploy tree — the *apex double-duty*
    # layout, where one directory served by one static host is both a human
    # website and a machine RubyGems source:
    #
    #   out/index.html          presentation (copied from the repo's site/ dir)
    #   out/catalog.html        browse Spinel-compatible gems (ledger + metadata)
    #   out/assets/…            shared CSS
    #   out/versions  out/names  out/info/<gem>  out/gems/<file>.gem
    #                           the Compact Index (only when a --store is given)
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

      # Default downloads floor for the catalog's "hide low-signal gems" toggle —
      # weeds out test / security-researcher / throwaway gems (the exfil PoC has
      # ~580 downloads; rake has ~1.3B). Tunable via SPINEL_CATALOG_MIN_DOWNLOADS.
      MIN_DOWNLOADS = Integer(ENV.fetch("SPINEL_CATALOG_MIN_DOWNLOADS", "1000"))

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
        File.write(File.join(out, "catalog.html"), catalog_html)
        compact_index(out, store, min_verdict) if store
        out
      end

      private

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
      def rows
        latest = {}
        @ledger.each { |v| latest[v.gem] = v if v.rev == rev }
        latest.values.map do |v|
          md = meta[v.gem] || {}
          Row.new(gem: v.gem, version: v.version, verdict: v.verdict,
                  notes: (v.reasons + v.risks).first(8).join(", "),
                  downloads: md["downloads"].to_i, info: md["info"],
                  updated: md["updated"], homepage: md["homepage"])
        end.sort_by { |r| [-r.downloads, r.gem.downcase] }
      end

      def catalog_html
        rs = rows
        counts = Hash.new(0)
        rs.each { |r| counts[r.verdict] += 1 }
        ok = counts["verified"] + counts["clean"]

        body = +""
        body << %(<p class="lede">The compatibility ledger as of <code>#{h rev}</code> — )
        body << %(<strong>#{rs.size}</strong> gems surveyed, <strong>#{ok}</strong> compatible )
        body << %((clean + verified), ranked by downloads. Verdicts are forward-compatible: )
        body << %(keyed on the Spinel revision, a gem rejected today clears the moment the )
        body << %(feature it needs lands.</p>\n)

        body << %(<div class="filters">\n)
        VERDICT_ORDER.each do |v|
          body << %(  <button data-verdict="#{v}" class="chip #{v}">#{GLYPH[v]} #{v} <span>#{counts[v]}</span></button>\n)
        end
        body << %(  <button data-verdict="" class="chip all on">all <span>#{rs.size}</span></button>\n)
        body << %(  <input id="q" type="search" placeholder="filter by gem name…" autocomplete="off">\n)
        body << %(  <label class="floor"><input type="checkbox" id="floor" checked> )
        body << %(hide low-signal gems (&lt; #{fmt_n MIN_DOWNLOADS} downloads)</label>\n)
        body << %(</div>\n)

        body << %(<table id="catalog"><thead><tr><th>verdict</th><th>gem</th>)
        body << %(<th class="num">downloads</th><th>updated</th><th>description</th></tr></thead><tbody>\n)
        rs.each do |r|
          gem_cell = r.homepage ? %(<a href="#{h r.homepage}" rel="noopener nofollow">#{h r.gem}</a>) : h(r.gem)
          body << %(<tr data-verdict="#{r.verdict}" data-gem="#{h r.gem.downcase}" data-dl="#{r.downloads}">)
          body << %(<td class="v #{r.verdict}" title="#{h r.notes}">#{GLYPH[r.verdict]} #{r.verdict}</td>)
          body << %(<td class="g">#{gem_cell} <span class="ver">#{h r.version}</span></td>)
          body << %(<td class="num">#{fmt_n r.downloads}</td>)
          body << %(<td class="upd">#{fmt_date r.updated}</td>)
          body << %(<td class="desc">#{h truncate(r.info, 140)}</td></tr>\n)
        end
        body << "</tbody></table>\n"

        page("Catalog — SpinelGems", body, script: catalog_js)
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
          <header><a class="brand" href="/">SpinelGems</a>
            <nav><a href="/">Home</a> <a href="/catalog.html">Catalog</a>
              <a href="https://github.com/OriPekelman/spinelgems">GitHub</a></nav>
          </header>
          <main>
          <h1>Spinel-compatible gems</h1>
          #{body}
          </main>
          <footer>Pre-release · verdicts keyed on the Spinel engine revision · <a href="/">spinelgems.org</a></footer>
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

      def catalog_js
        "const FLOOR = #{MIN_DOWNLOADS};\n" + CATALOG_JS
      end

      CATALOG_JS = <<~'JS'
        const q = document.getElementById('q');
        const floor = document.getElementById('floor');
        const rows = [...document.querySelectorAll('#catalog tbody tr')];
        let verdict = '';
        function apply() {
          const term = q.value.trim().toLowerCase();
          const hideLow = floor.checked;
          for (const tr of rows) {
            const okV = !verdict || tr.dataset.verdict === verdict;
            const okQ = !term || tr.dataset.gem.includes(term);
            const okF = !hideLow || (+tr.dataset.dl) >= FLOOR;
            tr.style.display = (okV && okQ && okF) ? '' : 'none';
          }
        }
        q.addEventListener('input', apply);
        floor.addEventListener('change', apply);
        for (const b of document.querySelectorAll('.chip')) {
          b.addEventListener('click', () => {
            verdict = b.dataset.verdict;
            document.querySelectorAll('.chip').forEach(x => x.classList.toggle('on', x === b));
            apply();
          });
        }
        apply();
      JS
    end
  end
end
