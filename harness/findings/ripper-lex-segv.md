# Finding: CRuby `Ripper.lex` SEGV (upstream, not spinel)

Surfaced 2026-07-06 as the segfault at the tail of every corpus reprobe
(`bin/reprobe-corpus.sh:119`, the `survey --jobs 1 --out report.md` aggregation).

## It is NOT what it looked like

- **Not the report.md aggregator, and not a `matz/spinel` bug.** It's a **CRuby
  3.4.9 `Ripper` segfault**, reached from `Probe#code_only` (`probe.rb`), which
  calls `Ripper.lex` in the risk static-scan.
- `Ripper.lex` **and** `Ripper.sexp` SEGV (`[BUG] Segmentation fault at 0x19`,
  exit 139) deterministically. The **normal parser raises `SyntaxError`**
  cleanly and **`Prism.parse` handles it** without crashing → specific to
  Ripper's legacy parse.y path. A SEGV can't be rescued, so `code_only`'s
  `rescue StandardError` was useless.
- In the sharded reprobe a crashing gem just loses its verdict (`xargs ... || true`);
  in the single-threaded aggregation it takes down the whole run before
  report.md is written.

## Trigger

A gem shipping an **ERB template as a plain `.rb`**:
`astrapi-0.0.7/lib/template_lexer.rb` (`module <%=mm.name%>`, `<%=apply_regexp%>`
inside a nested `case`). Minimized to **8 lines** — see `ripper-lex-segv.rb`.
Essential elements: nested `case`, an `<%=x%>` token before the inner `when`s (a
bare `%` does not reproduce), and inner `when` clauses using assignments.

| call | 8-line repro |
|---|---|
| `Ripper.lex` | **SEGV** (139) |
| `Ripper.sexp` | **SEGV** (139) |
| `RubyVM::InstructionSequence.compile` | `SyntaxError` (graceful) |
| `Prism.parse` | graceful |

## Resolution

- **Local fix** (`probe.rb`, commit `27d2281`): `code_only` gates `Ripper.lex`
  on `Prism.parse(src).success?` — skip Ripper on any source that doesn't fully
  parse. Covers the whole class of Ripper-crashing inputs, not just astrapi.
  Remove the gate once Ripper is fixed upstream.
- **Upstream**: reported to bugs.ruby-lang.org (Ruby core / Ripper), not
  `matz/spinel` — the spinel compiler is not involved.
