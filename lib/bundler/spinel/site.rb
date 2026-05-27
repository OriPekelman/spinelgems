require "fileutils"
require "cgi"

module Bundler
  module Spinel
    # Builds the static spinelgems.org deploy tree — the *apex double-duty*
    # layout, where one directory served by one static host is both a human
    # website and a machine RubyGems source:
    #
    #   out/index.html          presentation (copied from the repo's site/ dir)
    #   out/catalog.html        browse Spinel-compatible gems (from the ledger)
    #   out/assets/…            shared CSS
    #   out/versions  out/names  out/info/<gem>  out/gems/<file>.gem
    #                           the Compact Index (only when a --store is given)
    #
    # The reserved Compact Index paths and the human paths don't collide, so
    # `source "https://spinelgems.org"` in a Gemfile resolves against the curated
    # source while a browser at the same origin gets the site. The catalog is the
    # human-readable view of the *same* ledger the gate and the curated source
    # are built on. Static + CRuby-rendered today; the dogfood target is to serve
    # the identical tree from a Spinel-compiled Tep app (see ARCHITECTURE.md).
    class Site
      SRC = File.expand_path("../../../site", __dir__) # the repo's site/ source dir

      VERDICT_ORDER = %w[verified clean risky rejected].freeze
      GLYPH = { "verified" => "★", "clean" => "✓", "risky" => "~", "rejected" => "✗" }.freeze

      Row = Struct.new(:gem, :version, :verdict, :notes, keyword_init: true)

      def initialize(ledger: Ledger.new, engine: Engine.new, src: SRC)
        @ledger = ledger
        @engine = engine
        @src = src
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
                  engine: @engine, min_verdict: min).write_static(out)
      end

      # --- catalog (the ledger, for humans) ---------------------------------

      # Latest verdict per gem at the current engine rev, verdict-ranked.
      def rows
        rev = @engine.rev
        latest = {}
        @ledger.each { |v| latest[v.gem] = v if v.rev == rev }
        latest.values.map do |v|
          Row.new(gem: v.gem, version: v.version, verdict: v.verdict,
                  notes: (v.reasons + v.risks).first(8).join(", "))
        end.sort_by { |r| [VERDICT_ORDER.index(r.verdict) || 9, r.gem.downcase] }
      end

      def catalog_html
        rs = rows
        counts = Hash.new(0)
        rs.each { |r| counts[r.verdict] += 1 }
        ok = counts["verified"] + counts["clean"]

        body = +""
        body << %(<p class="lede">The compatibility ledger as of <code>#{h @engine.rev}</code> — )
        body << %(<strong>#{rs.size}</strong> gems surveyed, <strong>#{ok}</strong> compatible )
        body << %((clean + verified). Verdicts are forward-compatible: keyed on the Spinel )
        body << %(revision, a gem rejected today clears the moment the feature it needs lands.</p>\n)

        body << %(<div class="filters">\n)
        VERDICT_ORDER.each do |v|
          body << %(  <button data-verdict="#{v}" class="chip #{v}">#{GLYPH[v]} #{v} <span>#{counts[v]}</span></button>\n)
        end
        body << %(  <button data-verdict="" class="chip all">all <span>#{rs.size}</span></button>\n)
        body << %(  <input id="q" type="search" placeholder="filter by gem name…" autocomplete="off">\n</div>\n)

        body << %(<table id="catalog"><thead><tr><th>verdict</th><th>gem</th><th>version</th><th>notes</th></tr></thead><tbody>\n)
        rs.each do |r|
          body << %(<tr data-verdict="#{r.verdict}" data-gem="#{h r.gem.downcase}">)
          body << %(<td class="v #{r.verdict}">#{GLYPH[r.verdict]} #{r.verdict}</td>)
          body << %(<td class="g">#{h r.gem}</td><td class="ver">#{h r.version}</td>)
          body << %(<td class="notes">#{h r.notes}</td></tr>\n)
        end
        body << "</tbody></table>\n"

        page("Catalog — SpinelGems", body, script: CATALOG_JS)
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

      CATALOG_JS = <<~'JS'
        const q = document.getElementById('q');
        const rows = [...document.querySelectorAll('#catalog tbody tr')];
        let verdict = '';
        function apply() {
          const term = q.value.trim().toLowerCase();
          for (const tr of rows) {
            const okV = !verdict || tr.dataset.verdict === verdict;
            const okQ = !term || tr.dataset.gem.includes(term);
            tr.style.display = (okV && okQ) ? '' : 'none';
          }
        }
        q.addEventListener('input', apply);
        for (const b of document.querySelectorAll('.chip')) {
          b.addEventListener('click', () => {
            verdict = b.dataset.verdict;
            document.querySelectorAll('.chip').forEach(x => x.classList.toggle('on', x === b));
            apply();
          });
        }
      JS
    end
  end
end
