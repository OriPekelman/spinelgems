require "cgi"
require_relative "site"

module Bundler
  module Spinel
    # The "build-it-first" roadmap page: which gems, if made to compile, unblock
    # the most of the ecosystem. Reads the committed
    # harness/load-bearing/targets.tsv (transitive load-bearing + buildability
    # impact, precomputed from the local dependency graph) and renders a clear,
    # status-coloured table. Static, committed in site/ like the history page.
    class LoadBearing
      DATA = File.expand_path("../../../harness/load-bearing/targets.tsv", __dir__)
      GLYPH = Site::GLYPH

      # Buildability snapshot @ 478cc93 (from harness/load-bearing/buildability.rb).
      BUILDABLE = 86_045
      BLOCKED   = 45_670
      REJECTED  = 58_368

      def initialize(data = DATA) = (@data = data)

      def build_html(out)
        rows = File.exist?(@data) ? File.readlines(@data)[1..].map { |l| l.chomp.split("\t") } : []
        compiler = rows.select { |r| r[7] == "compiler" }.sort_by { |r| -r[1].to_i }
        File.write(out, page("Load-bearing gems — SpinelGems", body(compiler, rows)))
        out
      end

      private

      def body(compiler, all)
        b = +""
        b << "<h1>Load-bearing gems</h1>\n"
        b << %(<p class="lede">A gem matters to the ecosystem by how many gems pull it in )
        b << %(<em>transitively</em> — directly, or as a dependency of a dependency, turtles all )
        b << %(the way down. If Spinel can't compile a load-bearing gem, nothing above it can ship )
        b << %(either. This is the build-it-first roadmap.</p>\n)

        b << %(<div class="stat-row">\n)
        b << stat("buildable", BUILDABLE, "whole dependency tree compiles")
        b << stat("blocked", BLOCKED, "compiles itself — but a dependency is rejected")
        b << stat("rejected", REJECTED, "doesn't compile")
        b << %(</div>\n)
        b << %(<p class="note">~<strong>#{fmt(BLOCKED)}</strong> gems compile on their own but )
        b << %(can't actually be used because something beneath them is rejected. Fixing a load-bearing )
        b << %(blocker flows <em>up</em> the tree — its dependents become buildable too.</p>\n)

        b << %(<h2>Build-it-first targets</h2>\n)
        b << %(<p class="sub">Ranked by <strong>impact</strong> — how many blocked gems become )
        b << %(buildable if this one alone is fixed. Filtered to <strong>compiler-fixable</strong> )
        b << %(failures: the native (C-extension) and heavy-metaprogramming (Rails-shaped) clusters )
        b << %(are deliberately set aside as not the first target here. Each row carries two ways to )
        b << %(fix it — a focused Spinel issue, or, for a small library, a PR to the gem itself.</p>\n)

        b << %(<table id="catalog"><thead><tr>)
        b << %(<th class="num">impact</th><th>gem</th><th>status</th><th class="num">load-bearing</th>)
        b << %(<th>failure</th><th class="num">lib size</th><th>fix</th></tr></thead><tbody>\n)
        compiler.first(120).each do |r|
          gem, sole, _reach, transit, _dl, verdict, ftype, _ach, files, loc = r
          fi = files.to_i
          strat = fi.positive? && fi <= 12 ? %(<span class="badge human">lib PR</span> small — #{fi} files) :
                  %(<span class="badge rubric">Spinel issue</span>)
          b << %(<tr>)
          b << %(<td class="num"><strong>#{fmt sole}</strong></td>)
          b << %(<td class="g">#{h gem}</td>)
          b << %(<td class="v #{verdict}">#{GLYPH[verdict] || '?'} #{h verdict}</td>)
          b << %(<td class="num">#{fmt transit}</td>)
          b << %(<td><span class="badge rubric">#{h ftype}</span></td>)
          b << %(<td class="num">#{fi.positive? ? "#{fi}f / #{loc}L" : "—"}</td>)
          b << %(<td>#{strat}</td>)
          b << %(</tr>\n)
        end
        b << "</tbody></table>\n"

        nat = all.count { |r| r[7] == "native" }; mp = all.count { |r| r[7] == "metaprog" }
        b << %(<p class="meta">Set aside as not-first-target: <strong>#{nat}</strong> native )
        b << %(C-extension blockers (need FFI/ext vendoring) and <strong>#{mp}</strong> heavy-metaprogramming )
        b << %(blockers (the Rails ecosystem). Method + data: )
        b << %(<a href="https://github.com/OriPekelman/spinelgems/blob/main/docs/load-bearing-gems.md">docs/load-bearing-gems.md</a> · )
        b << %(<a href="https://github.com/OriPekelman/spinelgems/blob/main/harness/load-bearing/">harness/load-bearing/</a>. )
        b << %(Built locally from the gem cache's dependency graph; impact is per engine revision.</p>\n)
        b
      end

      def stat(cls, n, label)
        %(  <div class="stat #{cls}"><b>#{fmt n}</b><span>#{label}</span></div>\n)
      end

      def fmt(n)
        n = n.to_i
        n >= 1000 ? "#{(n / 1000.0).round(1)}k" : n.to_s
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
            <nav><a href="/">Home</a> <a href="/catalog">Catalog</a> <a href="/load-bearing.html">Load-bearing</a>
              <a href="/history.html">History</a> <a href="https://github.com/OriPekelman/spinelgems">GitHub</a></nav></header>
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
