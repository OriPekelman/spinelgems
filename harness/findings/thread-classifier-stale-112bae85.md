# The probe's thread/mutex risk flag went stale at 2026.09.12

**Status:** finding about OUR tooling, not a Spinel bug. No issue to file upstream.
**Engine:** `112bae85` (release `2026.09.12`). **Corpus:** 192,038 gems.

## What the probe currently asserts

`lib/bundler/spinel/probe.rb` keeps `Thread.new` / `Mutex.new` / `Mutex_m` in
`RISK_TOKENS`, on this premise (verbatim from the comment):

> Thread/Mutex run single-threaded since matz/spinel#1360 — correct for
> defensive use (a mutex guarding state, Thread.new for a value), but
> degenerate for genuine concurrency: compiles, flagged, fails `check --strict`.

That was true when it was written. It is no longer true.

## What the release actually does

`docs/limitations.md` at tag `2026.09.12` lists `Thread` real parallelism as
**implemented**:

> a true M:N runtime (no GVL): N OS workers (`min(online cores,
> SPINEL_WORKERS)`) run green threads in parallel over a stop-the-world GC,
> with real `Mutex`/`Queue`/`SizedQueue`/`ConditionVariable`. A monitor thread
> timeslices CPU-bound threads (~10ms quantum) so a thread looping without
> yielding cannot starve its siblings.

Verified on this box against CRuby 3.4.9, compiled at `112bae85`:

- 8 threads summing into a `Mutex`-guarded total, plus a `Queue`
  producer/consumer pair: **byte-identical to CRuby** (`total=3600000`,
  `queue=[0, 1, 2, 3, 4]`).
- 4 threads each `sleep 1`, joined: **completes in under 2s**, i.e. the sleeps
  overlap. A single-threaded lowering would take 4s. `SPINEL_SCHED_STATS=1`
  reports real monitor turns and polls.

So the "degenerate for genuine concurrency" half of the premise is simply gone.

## Residual thread caveats at this release (all narrow)

- `Monitor#class` reports `Thread::Mutex` — a name difference only; mutual
  exclusion and reentrancy behave as CRuby's.
- FIFO between two threads hangs **on macOS**; Linux answers what CRuby answers.
  The catalog is built on Linux.
- `#inspect` on a `Fiber` or `Thread` **refuses to compile**, and a `SizedQueue`
  prints as `Thread::Queue`. The compile-time refusal is already caught by the
  compile probe, so it needs no static token.

None of these justify a blanket risk flag on every gem that touches a thread.

## What it costs the catalog

At `112bae85`, of the 47,027 risky gems:

| | gems |
|---|---|
| carry ANY thread/mutex risk | 6,224 |
| whose **only** blocker is thread/mutex (would become clean) | **2,492** |

The other 3,732 also carry `send` (2,416), `define_method` (1,392),
`method_missing` (1,298), `instance_eval` (1,159) and friends, so they stay
risky on their own merits.

For scale: **2,492 is seven times the entire compiler-driven movement of this
cycle** (clean +340 against 55638986). The largest single distortion in the
catalog right now is our own stale assumption, not anything the compiler does.

## Proposed change

Drop `thread`, `mutex` and `mutex_m` from `RISK_TOKENS` in
`lib/bundler/spinel/probe.rb`. They were demoted from `HARD_REJECT_TOKENS` to
`RISK_TOKENS` when #1360 made them *run*; the M:N runtime is the second half of
that same migration and retires the flag entirely.

This is a methodology change that moves ~2,492 gems risky -> clean, so it is
recorded here rather than applied silently. It should land as its own commit,
before the next promotion, so the promotion's delta is not conflated with it.

Do NOT re-derive the number from a later corpus without re-running the probe:
the count is a property of this rev's ledger.
