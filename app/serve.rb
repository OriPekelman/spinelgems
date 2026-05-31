# spinelgems.org — served by a Spinel-compiled Tep binary on Upsun.
#
#   tep build app/serve.rb -o serve_bin ;  ./serve_bin -p $PORT
#
# Dynamic, server-queried catalog over a read-only SQLite DB built at deploy
# (`spinel-compat build-db --out public/catalog.db`). Replaces the static
# per-verdict HTML split + REJECTED_CAP — every query returns one page.
#
# NOT passed to spinel directly: the tep translator rewrites the do/end route
# blocks into Tep::Handler subclasses first. Style is string-concat (not
# interpolation) and simple types, which the translator/spinel handle best.
require 'sinatra' # ignored by the translator; documentation-only

set :public_dir, './public'   # runtime-relative (no __dir__ at compile time)

DB_PATH = './public/catalog.db'

# ---- render helpers (class self-methods so routes can call V.x) ----
class V
  ORDER = ["verified", "loaded", "clean", "risky", "rejected"]

  def self.glyph(v)
    return "★" if v == "verified"  # star
    return "○" if v == "loaded"    # circle
    return "✓" if v == "clean"     # check
    return "~"      if v == "risky"
    return "✗" if v == "rejected"  # cross
    "?"
  end

  # 1326859499 -> "1.3B", 342000 -> "342.0k"
  def self.fmt_n(n)
    return n.to_s if n < 1000
    return (n / 1000).to_s + "." + ((n % 1000) / 100).to_s + "k" if n < 1000000
    return (n / 1000000).to_s + "." + ((n % 1000000) / 100000).to_s + "M" if n < 1000000000
    (n / 1000000000).to_s + "." + ((n % 1000000000) / 100000000).to_s + "B"
  end

  def self.brand
    "<a class=brand href=\"/\"><svg class=gem viewBox=\"0 0 24 24\" aria-hidden=true>" +
    "<path d=\"M6 3h12l4 6-10 13L2 9z\" fill=\"#7b2d8e\"/>" +
    "<path d=\"M6 3 2 9l10 13z\" fill=\"#5a1f6b\" opacity=\".55\"/>" +
    "<path d=\"M18 3l4 6-10 13z\" fill=\"#b14fc4\"/>" +
    "<path d=\"M6 3h12l-6 6z\" fill=\"#d98ee8\"/></svg>SpinelGems</a>"
  end

  def self.footer
    "<footer><div class=foot-wrap><div class=foot-built>" +
    "<span class=by><svg width=16 height=16 viewBox=\"0 0 24 24\" aria-hidden=true>" +
    "<path d=\"M6 3h12l4 6-10 13L2 9z\" fill=\"#b31217\"/>" +
    "<path d=\"M6 3 2 9l10 13z\" fill=\"#7a0c0f\"/>" +
    "<path d=\"M18 3l4 6-10 13z\" fill=\"#d42b2b\"/>" +
    "<path d=\"M6 3h12l-6 6z\" fill=\"#e86a6a\"/></svg> " +
    "<a href=\"https://github.com/matz/spinel\">Spinel</a>-compiled Ruby</span>" +
    "<span class=by>Built with <a href=\"https://github.com/OriPekelman/tep\">Tep</a></span>" +
    "<span class=by><svg width=16 height=16 viewBox=\"0 0 24 24\" aria-hidden=true>" +
    "<circle cx=12 cy=12 r=4.4 fill=\"#ff6b57\"/>" +
    "<g stroke=\"#ff6b57\" stroke-width=1.7 stroke-linecap=round>" +
    "<path d=\"M12 2.2v2.6\"/><path d=\"M12 19.2v2.6\"/><path d=\"M2.2 12h2.6\"/><path d=\"M19.2 12h2.6\"/>" +
    "<path d=\"M5.1 5.1l1.8 1.8\"/><path d=\"M17.1 17.1l1.8 1.8\"/><path d=\"M18.9 5.1l-1.8 1.8\"/><path d=\"M6.9 17.1l-1.8 1.8\"/></g></svg> " +
    "Hosted on <a href=\"https://upsun.com\">Upsun</a></span></div>" +
    "<p class=foot-note>Pre-release &middot; verdicts keyed on the Spinel engine revision &middot; " +
    "<a href=\"https://github.com/OriPekelman/spinelgems\">source &amp; RFC on GitHub</a></p></div></footer>"
  end

  def self.page(title, body)
    "<!doctype html>\n<html lang=en>\n<head><meta charset=utf-8>" +
    "<meta name=viewport content=\"width=device-width, initial-scale=1\">" +
    "<title>" + Tep.h(title) + "</title>" +
    "<link rel=stylesheet href=\"/assets/style.css\"></head>\n<body>\n" +
    "<header>" + V.brand +
    "<nav><a href=\"/\">Home</a> <a href=\"/catalog\">Catalog</a> <a href=\"/history.html\">History</a> " +
    "<a href=\"https://github.com/OriPekelman/spinelgems\">GitHub</a></nav></header>\n" +
    "<main>\n" + body + "\n</main>\n" + V.footer + "\n</body>\n</html>\n"
  end

  # chip strip linking to /catalog?verdict=V; `active` marks the current one.
  def self.chips(counts_csv, active)
    out = "<p class=\"chip-strip\">"
    i = 0
    while i < ORDER.length
      v = ORDER[i]
      n = V.count_in(counts_csv, v)
      cls = "chip " + v
      cls = cls + " on" if v == active
      out = out + "<a href=\"/catalog?verdict=" + v + "\" class=\"" + cls + "\">" +
            V.glyph(v) + " " + v + " <span>" + V.fmt_n(n) + "</span></a> "
      i = i + 1
    end
    out + "</p>\n"
  end

  # pull N out of a "verified:28,loaded:393,..." string for verdict v
  def self.count_in(csv, v)
    parts = csv.split(",")
    i = 0
    while i < parts.length
      kv = parts[i].split(":")
      return kv[1].to_i if kv[0] == v
      i = i + 1
    end
    0
  end

  # whitelist sort -> ORDER BY clause (never interpolate raw input)
  def self.order_by(sort)
    return "gem_lower ASC" if sort == "name"
    return "updated DESC, downloads DESC" if sort == "updated"
    "downloads DESC, gem_lower ASC"
  end

  # rubric tag -> human label (the "here's what it'd take" signal)
  def self.rubric_label(t)
    return "needs a dep" if t == "needs-dep"
    return "needs load-path" if t == "load-path"
    return "needs stdlib" if t == "needs-stdlib"
    return "codegen bug" if t == "codegen"
    return "miscompiles" if t == "miscompile"
    return "unsupported call" if t == "unsupported"
    return "build error" if t == "build-error"
    return "smoke error" if t == "smoke-error"
    ""
  end

  # composable signal badges for one row (human/tests ints, rubric tag)
  def self.signals(human, tests, rubric)
    s = ""
    s = s + "<span class=\"badge human\">👤 human</span>" if human == 1
    s = s + "<span class=\"badge tests\">✪ tests</span>" if tests == 1
    lbl = V.rubric_label(rubric)
    s = s + "<span class=\"badge rubric\">" + lbl + "</span>" if lbl.length > 0
    s
  end
end

# ---- landing: live verdict counts + intro + search ----
get '/' do
  db = Tep::SQLite.new
  db.open(DB_PATH)
  counts_csv = ""
  db.prepare("SELECT verdict, COUNT(*) FROM catalog GROUP BY verdict")
  while db.step == 1
    counts_csv = counts_csv + db.col_str(0) + ":" + db.col_int(1).to_s + ","
  end
  db.finalize
  rev = db.first_str("SELECT value FROM catalog_meta WHERE key = ?", "rev")
  total = db.first_str("SELECT value FROM catalog_meta WHERE key = ?", "total")
  built = db.first_str("SELECT value FROM catalog_meta WHERE key = ?", "built_at")
  db.close

  # The catalog DB is immutable per deploy; key the validator on its build stamp
  # so the edge (Cloudflare) caches and clients get a 304 until the next deploy.
  response.cache_control("public, max-age=120")
  response.etag(built + "|home")

  verified_n = V.count_in(counts_csv, "verified")
  body = "<h1>Dependencies for Spinel projects</h1>\n" +
    "<p class=lede><a href=\"https://github.com/matz/spinel\">Spinel</a> is a new " +
    "ahead-of-time Ruby compiler. SpinelGems proposes a plain <code>Gemfile</code> as " +
    "the way to share Spinel code <em>and</em> to reach into the huge existing Ruby " +
    "ecosystem. The catch: most gems won't compile under Spinel <em>yet</em> &mdash; its " +
    "scope is deliberately limited and still growing &mdash; so this catalog tracks what " +
    "works today, at each engine revision.</p>\n" +
    "<div class=stat-row>" +
    "<div class=\"stat verified\"><b>" + V.fmt_n(verified_n) + "</b><span>★ behaviour-verified</span></div>" +
    "<div class=stat><b>" + total + "</b><span>gems surveyed</span></div>" +
    "</div>\n" +
    "<p class=meta>Compatibility ledger as of <code>" + Tep.h(rev) + "</code>.</p>\n" +
    "<form class=filters method=get action=\"/catalog\">" +
    "<input id=q name=q type=search placeholder=\"search a gem…\" autocomplete=off> " +
    "<button type=submit>Browse catalog</button></form>\n" +
    "<div class=filters>" + V.chips(counts_csv, "") + "</div>\n" +
    "<h2>What the verdicts mean</h2>\n" +
    "<table class=ladder>" +
    "<tr><td class=\"v verified\">★ verified</td><td>full surface compiles <em>and</em> a behaviour smoke matches CRuby &mdash; trust this one</td></tr>" +
    "<tr><td class=\"v loaded\">○ loaded</td><td>compiles + loads identically (require-only); logic untested</td></tr>" +
    "<tr><td class=\"v clean\">✓ clean</td><td>compiles (a cheap lower bound); no behaviour run</td></tr>" +
    "<tr><td class=\"v risky\">~ risky</td><td>compiles, but uses constructs Spinel degrades silently</td></tr>" +
    "<tr><td class=\"v rejected\">✗ rejected</td><td>doesn't compile, or a caught miscompile &mdash; the reason names the missing feature</td></tr>" +
    "</table>\n" +
    "<h2>Signals</h2>\n" +
    "<p class=note>The verdict is the rank; gems also carry orthogonal <em>signals</em>, shown as badges in the catalog:</p>\n" +
    "<table class=ladder>" +
    "<tr><td><span class=\"badge human\">👤 human</span></td><td>a person attests it works in real use &mdash; the highest-trust signal</td></tr>" +
    "<tr><td><span class=\"badge tests\">✪ tests</span></td><td>the gem's own test suite passes under Spinel (stronger than a hand smoke, zero human effort)</td></tr>" +
    "<tr><td><span class=\"badge rubric\">rubric</span></td><td>on non-verified gems: <em>why</em> not yet (needs-dep &middot; load-path &middot; miscompiles &middot; …)</td></tr>" +
    "</table>\n" +
    "<p class=note>Verdicts are forward-compatible: a gem rejected today clears the moment " +
    "the feature it needs lands in Spinel. Raw data: " +
    "<a href=\"https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/compat.jsonl\">compat.jsonl</a> &middot; " +
    "<a href=\"https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/report.md\">report.md</a></p>\n"
  V.page("SpinelGems — dependencies for Spinel projects", body)
end

# ---- the queryable catalog ----
# Branchless: one fixed filter SQL with empty params as no-ops via
# `(? = '' OR col = ?)`, always binding the same positions. Keeping the SQL +
# bind sequence constant avoids a Spinel miscompile (pin 96b21e6) that segfaulted
# the conditional no-verdict build path.
get '/catalog' do
  verdict = params["verdict"]
  q = params["q"]
  sort = params["sort"]
  min = 1000
  min = params["min_downloads"].to_i if params["min_downloads"].length > 0
  page = params["page"].to_i
  page = 1 if page < 1
  per = 100
  off = (page - 1) * per
  order = V.order_by(sort)
  like = "%" + q + "%"
  # Integer "match-all" flags (1 = no filter). NOT empty-string compares:
  # Tep::SQLite bind_str("") binds NULL, so `? = ''` would be `NULL = ''` → NULL
  # → zero rows. `? = 1` with a bound int is unambiguous; verdict/like are still
  # bound (harmless when the flag short-circuits the OR to true).
  vflag = 1
  vflag = 0 if verdict.length > 0
  qflag = 1
  qflag = 0 if q.length > 0
  filt = "downloads >= ? AND (? = 1 OR verdict = ?) AND (? = 1 OR gem_lower LIKE ?)"

  db = Tep::SQLite.new
  db.open(DB_PATH)

  # Cache: key on the build stamp + the full query (the DB is immutable per
  # deploy, so this response is byte-stable until the next deploy). Cloudflare
  # caches it; the server auto-304s a conditional GET with the matching ETag.
  built = db.first_str("SELECT value FROM catalog_meta WHERE key = ?", "built_at")
  response.cache_control("public, max-age=120")
  response.etag(built + "|" + verdict + "|" + q + "|" + min.to_s + "|" + sort + "|" + page.to_s)

  counts_csv = ""
  db.prepare("SELECT verdict, COUNT(*) FROM catalog GROUP BY verdict")
  while db.step == 1
    counts_csv = counts_csv + db.col_str(0) + ":" + db.col_int(1).to_s + ","
  end
  db.finalize

  db.prepare("SELECT COUNT(*) FROM catalog WHERE " + filt)
  db.bind_int(1, min)
  db.bind_int(2, vflag)
  db.bind_str(3, verdict)
  db.bind_int(4, qflag)
  db.bind_str(5, like)
  matched = 0
  matched = db.col_int(0) if db.step == 1
  db.finalize

  rows = ""
  db.prepare("SELECT gem, version, verdict, downloads, info, updated, homepage, human, tests, rubric FROM catalog WHERE " +
             filt + " ORDER BY " + order + " LIMIT ? OFFSET ?")
  db.bind_int(1, min)
  db.bind_int(2, vflag)
  db.bind_str(3, verdict)
  db.bind_int(4, qflag)
  db.bind_str(5, like)
  db.bind_int(6, per)
  db.bind_int(7, off)
  while db.step == 1
    g = db.col_str(0); ver = db.col_str(1); vd = db.col_str(2)
    dl = db.col_int(3); info = db.col_str(4); upd = db.col_str(5); home = db.col_str(6)
    hum = db.col_int(7); tst = db.col_int(8); rub = db.col_str(9)
    gcell = Tep.h(g)
    gcell = "<a href=\"" + Tep.h(home) + "\" rel=\"noopener nofollow\">" + Tep.h(g) + "</a>" if home.length > 0
    rows = rows + "<tr><td class=\"v " + vd + "\">" + V.glyph(vd) + " " + vd + "</td>" +
      "<td class=sig>" + V.signals(hum, tst, rub) + "</td>" +
      "<td class=g>" + gcell + " <span class=ver>" + Tep.h(ver) + "</span></td>" +
      "<td class=num>" + V.fmt_n(dl) + "</td>" +
      "<td class=upd>" + Tep.h(upd[0,10]) + "</td>" +
      "<td class=desc>" + Tep.h(info[0,140]) + "</td></tr>\n"
  end
  db.finalize
  db.close

  last = (matched + per - 1) / per
  head = "all gems"
  head = V.glyph(verdict) + " " + verdict if verdict.length > 0

  body = V.chips(counts_csv, verdict) +
    "<h2>" + head + " <span class=muted>&mdash; " + V.fmt_n(matched) + " match</span></h2>\n" +
    "<form class=filters method=get action=\"/catalog\">" +
    "<input type=hidden name=verdict value=\"" + Tep.h(verdict) + "\">" +
    "<input id=q name=q type=search placeholder=\"filter by gem name…\" value=\"" + Tep.h(q) + "\" autocomplete=off> " +
    "<button type=submit>Filter</button></form>\n" +
    "<table id=catalog><thead><tr><th>verdict</th><th>signals</th><th>gem</th>" +
    "<th class=num>downloads</th><th>updated</th><th>description</th></tr></thead><tbody>\n" +
    rows + "</tbody></table>\n"

  if last > 1
    qs = "verdict=" + verdict + "&q=" + q + "&min_downloads=" + min.to_s + "&sort=" + sort
    nav = "<p class=pager>"
    nav = nav + "<a href=\"/catalog?" + qs + "&page=" + (page - 1).to_s + "\">&larr; prev</a> " if page > 1
    nav = nav + "page " + page.to_s + " of " + last.to_s + " "
    nav = nav + "<a href=\"/catalog?" + qs + "&page=" + (page + 1).to_s + "\">next &rarr;</a>" if page < last
    body = body + nav + "</p>\n"
  end

  V.page(head + " gems — SpinelGems", body)
end
