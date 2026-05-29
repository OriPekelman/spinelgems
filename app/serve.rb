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

  def self.page(title, body)
    "<!doctype html>\n<html lang=en>\n<head><meta charset=utf-8>" +
    "<meta name=viewport content=\"width=device-width, initial-scale=1\">" +
    "<title>" + Tep.h(title) + "</title>" +
    "<link rel=stylesheet href=\"/assets/style.css\"></head>\n<body>\n" +
    "<header><a class=brand href=\"/\">SpinelGems</a>" +
    "<nav><a href=\"/\">Home</a> <a href=\"/catalog\">Catalog</a> " +
    "<a href=\"https://github.com/OriPekelman/spinelgems\">GitHub</a></nav></header>\n" +
    "<main>\n" + body + "\n</main>\n" +
    "<footer>Pre-release &middot; verdicts keyed on the Spinel engine revision &middot; " +
    "Hosted on <a href=\"https://upsun.com\" rel=noopener>Upsun</a> &middot; " +
    "Built with <a href=\"https://github.com/OriPekelman/tep\" rel=noopener>Tep</a> " +
    "(compiled by Spinel) &middot; <a href=\"/\">spinelgems.org</a></footer>\n" +
    "</body>\n</html>\n"
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
  db.close

  body = "<h1>Spinel-compatible gems</h1>\n" +
    "<p class=lede>Compatibility ledger as of <code>" + Tep.h(rev) + "</code> &mdash; " +
    "<strong>" + total + "</strong> gems surveyed, ranked by downloads in each tier. " +
    "Trust <strong>★ verified</strong> (full surface compiles <em>and</em> a behaviour " +
    "smoke matches CRuby), not <strong>✓ clean</strong> (a cheap lower bound) or " +
    "<strong>○ loaded</strong> (require-only). Verdicts are forward-compatible: a gem " +
    "rejected today clears the moment the feature it needs lands.</p>\n" +
    "<div class=filters>\n" + V.chips(counts_csv, "") + "</div>\n" +
    "<form class=filters method=get action=\"/catalog\">\n" +
    "<input id=q name=q type=search placeholder=\"filter by gem name…\" autocomplete=off> " +
    "<button type=submit>Browse catalog</button></form>\n" +
    "<p class=meta>Raw data: " +
    "<a href=\"https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/compat.jsonl\">compat.jsonl</a> &middot; " +
    "<a href=\"https://github.com/OriPekelman/spinelgems/blob/main/survey-193k/report.md\">report.md</a></p>\n"
  V.page("Catalog — SpinelGems", body)
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
  db.prepare("SELECT gem, version, verdict, downloads, info, updated, homepage FROM catalog WHERE " +
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
    gcell = Tep.h(g)
    gcell = "<a href=\"" + Tep.h(home) + "\" rel=\"noopener nofollow\">" + Tep.h(g) + "</a>" if home.length > 0
    rows = rows + "<tr><td class=\"v " + vd + "\">" + V.glyph(vd) + " " + vd + "</td>" +
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
    "<table id=catalog><thead><tr><th>verdict</th><th>gem</th>" +
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
