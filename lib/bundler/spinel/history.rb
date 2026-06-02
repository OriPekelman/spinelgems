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
            <nav><a href="/">Home</a> <a href="/catalog">Catalog</a> <a href="/history.html">History</a>
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
