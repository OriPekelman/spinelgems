# Minimal repro: CRuby `Ripper.lex` / `Ripper.sexp` SEGV on malformed input.
#
#   $ ruby -rripper -e 'Ripper.lex(File.read("harness/findings/ripper-lex-segv.rb"))'
#   .../ripper/lexer.rb:184: [BUG] Segmentation fault at 0x0000000000000019
#   ruby 3.4.9 (2026-03-11 revision 76cca827ab) +PRISM [aarch64-linux]
#
# Ripper.lex AND Ripper.sexp segfault (exit 139), deterministically. The same
# source under the normal parser raises SyntaxError (graceful, exit 1) and
# Prism.parse reports it invalid without crashing — so it is specific to
# Ripper's legacy parse.y path. A SEGV can't be rescued.
#
# Trigger (all essential; removing any makes it lex cleanly):
#   - a nested `case`
#   - an ERB-style `<%=x%>` token before the inner `when`s (a bare `%` does NOT
#     reproduce — it needs the `<%= ... %>` sequence)
#   - the inner `when` clauses must use assignments (`when b = g`)
#
# Found in the wild lexing ~189k rubygems sources: astrapi-0.0.7's
# lib/template_lexer.rb ships an ERB template as a plain .rb. In the sharded
# reprobe one such gem just loses its verdict; in the single-threaded
# `survey --jobs 1` aggregation it crashed the whole run before report.md was
# written (the segfault at the tail of every reprobe).
#
# Guarded in lib/bundler/spinel/probe.rb (code_only now gates Ripper on
# Prism.parse(src).success?). Reported upstream at bugs.ruby-lang.org.
#
# The 8 lines below ARE the repro (this header is comments; Ripper crashes on
# the whole file all the same). Keep them exactly as-is.
case
when a = f
case
<%=x%>
when b = g
when c = h
end
end
