# Load-bearing gems

> **Exploration** (branch `explore/load-bearing-gems`). Identify the gems most
> present in *dependencies of dependencies* — "turtles all the way down" — so we
> can prioritise the Spinel compiler work that unblocks the most of the ecosystem.

## The idea

A gem's importance to the ecosystem isn't how many gems *directly* list it
(`gem "foo"`), but how many gems *transitively* pull it in — directly, or as a
dependency of a dependency of a dependency. A 30-line shim with 26 direct
dependents can sit underneath 33,000 gems because the hubs everyone uses depend
on it. Those are the **load-bearing** gems: if Spinel can't compile them, nothing
above them in the tree can ship either.

## Method — built locally from the gem cache

No network, no external dataset. Each cached gem dir keeps either the original
`.gem` (whose `metadata.gz` is the authoritative spec) or a root `<name>.gemspec`;
we read **runtime dependencies** from both (`harness/load-bearing/`). From ~123k
spec sources we get a graph of **~138k gems / ~240k edges**.

- **Direct in-degree** — distinct gems that declare a dependency on X.
- **Transitive in-degree** — distinct gems that reach X through *any* dependency
  chain (reverse-reachability over the dep graph). This is the load-bearing
  measure.

In-degree is robust to a gem missing its *own* spec (≈40% of unpacked dirs have
no local spec — e.g. `activesupport`): a gem's score comes from its *dependents'*
specs, and we have 100k+ of those. Validation: direct in-degree reproduces the
known RubyGems "most depended-upon" ranking (activesupport, thor, nokogiri,
json, faraday, rails…), so the local graph is sound.

## What it found

**Transitive ≠ direct, and the gap is the whole point.** The most load-bearing
gems are often small/stdlib gems with modest direct counts:

| gem | transitive | direct | Spinel @ 95557f5 |
|---|---:|---:|---|
| logger | 41,579 | 314 | ✗ rejected |
| json | 37,340 | 4,305 | ✗ rejected |
| base64 | 37,192 | 260 | ✓ clean |
| ruby2_keywords | 33,287 | **26** | ✗ rejected |
| uri | 30,909 | 41 | ✗ rejected |
| concurrent-ruby | 30,173 | 492 | ✗ rejected |
| multi_json | 29,885 | 1,500 | ✗ rejected |
| bigdecimal | 29,136 | 148 | ✗ rejected |
| i18n | 27,155 | 939 | ✗ rejected |
| securerandom | 25,086 | 23 | ✗ rejected |
| activesupport | 25,070 | 8,052 | ✗ rejected |

(full top-200 in [`harness/load-bearing/top-load-bearing.tsv`](../harness/load-bearing/top-load-bearing.tsv))

**Two headline numbers** — of the top 50 load-bearing gems:
- **42 are `rejected`** under Spinel (master `95557f5`).
- **10 are Ruby default/stdlib gems** extracted to gems — `logger`, `json`,
  `uri`, `base64`, `bigdecimal`, `securerandom`, `benchmark`, `mutex_m`, `prism`,
  `racc`.

So the ecosystem's deepest, most-pulled-in foundations are overwhelmingly (a)
**stdlib default-gems** and (b) the **ActiveSupport/Rails + test cores**
(`i18n`, `tzinfo`, `concurrent-ruby`, `zeitwerk`, `rspec-*`, `minitest`), and
almost all are currently rejected. **This is the highest-leverage target list for
the compiler**: fixing a load-bearing rejected gem is *necessary* (though not
sufficient) to unblock its tens of thousands of transitive dependents. The stdlib
cluster especially is a small, finite set with enormous reach.

## Prior art / existing tools

The transitive-centrality cut here is the novel part; the underlying data and the
*direct* ranking have established sources worth cross-checking against:

- **RubyGems.org** publishes a "most depended upon" list — that's **direct**
  in-degree (matches ours), not transitive.
- **[deps.dev](https://deps.dev)** (Google) — dependency graphs + transitive
  *dependents* across ecosystems including RubyGems; the closest existing
  transitive view.
- **[libraries.io](https://libraries.io)** — "dependent packages/repositories"
  counts + SourceRank; a PageRank-flavoured importance score.
- **Bundler** resolves the same graph locally for a single project; we run it over
  the whole corpus.
- Academic: package-dependency-network centrality / software-supply-chain studies
  (PageRank/betweenness over npm, PyPI, RubyGems graphs) — the same shape of
  analysis applied to security/maintenance risk rather than compiler triage.

## Limitations & next steps

- **Per-version**: deps are read from the cached version of each gem, not resolved
  latest — fine for ranking, not for an exact lockfile.
- **Transitive computed for the top-1000 by direct** (the head); a full all-pairs
  pass would extend the long tail but wouldn't move the leaders.
- **Next**: a *buildability* pass — for each gem, is its entire transitive closure
  green? Rank gems by "would build if we fixed the following N rejected
  load-bearing deps", to find the cheapest cuts that turn whole subtrees green.
  The stdlib default-gem cluster is the obvious first cut.
