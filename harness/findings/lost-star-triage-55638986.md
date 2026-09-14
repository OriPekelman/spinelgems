# Lost-★ triage @ 55638986 (2026-08-25)

13 gems verified at the c51b0a1c catalog, behaviour-rejected at 55638986.
Each: regenerated verify-full harness, compiled at 55638986 vs c51b0a1c.

## 10 REQUIRE-GATE (honest, not filable)
activerecord-analyze, aws-sigv2, helpful_configuration, jericho,
json_rpc_handler, metasploit-payloads, prop, recent_ruby, yarn_lock_parser,
grosser-pomo — the gem's own code uses a bundled stdlib (digest/json/erb/…)
without an explicit `require`, so it now refuses at compile time
("X is provided by the bundled X library … add require"). Built at c51b0a1c,
correctly refuses at 55638986. Matches CRuby's documented interface — the
same require-gate that drives the whole 55638986 stricter+honest cycle.
These are the ★ tail of that policy; the gem must add the require to compile.

## 2 REAL CODEGEN REGRESSIONS (filed)
- **polyglot** 0.3.5 → **matz/spinel#4111**: module-ivar `@h ||= {}` unifies to
  incompatible C hash variants (sp_PolyPolyHash* vs sp_StrPolyHash*) on
  poly-key-write + String-key-read. #3975 family (String vs Sym; compile-time
  not SIGSEGV). Repro: polyglot-polyhash-variant-regression.rb (12 lines).
- **cloc** 0.9.0 → **matz/spinel#4112**: `File.open(p){|f| Marshal.load(f)}`
  mis-types the File.open return as sp_File* (const char* incompatible-pointer)
  when the block's value is untyped. Repro: fileopen-block-marshal-regression.rb
  (6 lines).

## 1 RUNTIME MISCOMPILE (needs localization)
- **make_me_a_gem_called** 0.1.3: builds at both engines, but at 55638986 the
  smoke runtime-errors `no implicit conversion of nil into String (TypeError)`
  where CRuby runs clean — a Spinel runtime miscompile (a method returns nil
  where a String is expected). NOT yet minimized; the two C-error regressions
  above were the clean wins. Candidate follow-up.
