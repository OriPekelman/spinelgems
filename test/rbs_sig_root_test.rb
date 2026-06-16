#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for sig/*.rbs as type roots (spinelgems#13): a gem's shipped RBS
# tree seeds the Spinel analyzer (`--rbs`) so uncalled public methods keep
# their declared param/return/ivar types instead of widening to int/poly —
# retiring hand-written seed blocks. Hermetic: a stub engine binary records
# its argv. Run: `ruby test/rbs_sig_root_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

FakeEngine = Struct.new(:bin, :dir, :rev) do
  def ensure! = true
end

# --- Verifier#resolve_rbs_root ----------------------------------------------
puts "resolve_rbs_root: :auto detects a shipped sig/, explicit dir wins, opt-out"
Dir.mktmpdir("rbsroot") do |dir|
  v = Bundler::Spinel::Verifier.new(nil, nil)
  check(v.send(:resolve_rbs_root, dir, :auto).nil?, "no sig/ -> nil")

  FileUtils.mkdir_p(File.join(dir, "sig", "nested"))
  File.write(File.join(dir, "sig", "nested", "a.rbs"), "class A\nend\n")
  check(v.send(:resolve_rbs_root, dir, :auto) == File.join(dir, "sig"),
        "sig/ with nested .rbs -> <dir>/sig")
  check(v.send(:resolve_rbs_root, dir, false).nil?, "rbs: false -> nil (opt-out)")

  other = File.join(dir, "elsewhere")
  FileUtils.mkdir_p(other)
  check(v.send(:resolve_rbs_root, dir, other) == other, "explicit DIR -> that dir")
end

# --- Verifier#run_spinel passes --rbs to the engine --------------------------
puts "\nrun_spinel: --rbs <root> reaches the compiler invocation"
Dir.mktmpdir("rbsspin") do |dir|
  argv_log = File.join(dir, "argv.log")
  stub = File.join(dir, "spinel-stub")
  # Records argv; emits the expected -o binary (itself a trivial script) so
  # run_spinel's "compiled ok" path executes it.
  File.write(stub, <<~SH)
    #!/bin/sh
    echo "$@" >> #{argv_log}
    out=""
    while [ $# -gt 0 ]; do [ "$1" = "-o" ] && out="$2"; shift; done
    printf '#!/bin/sh\\necho ok\\n' > "$out" && chmod +x "$out"
  SH
  File.chmod(0o755, stub)

  v = Bundler::Spinel::Verifier.new(FakeEngine.new(stub, dir, "test"), nil)
  harness = File.join(dir, "h.rb")
  File.write(harness, "puts 1\n")

  out, _err, ok = v.send(:run_spinel, harness, "/some/sig")
  argv = File.read(argv_log)
  check(ok && out.strip == "ok", "stubbed compile+run succeeds")
  check(argv.include?("--rbs /some/sig"), "argv carries --rbs root (got: #{argv.strip})")

  File.write(argv_log, "")
  v.send(:run_spinel, harness, nil)
  check(!File.read(argv_log).include?("--rbs"), "no root -> no --rbs flag")
end

# --- Vendorer: sig/ rides along + aggregates into one --rbs root -------------
puts "\nvendor placement: sig/ copied per gem and aggregated under <into>/sig/<name>"
Dir.mktmpdir("rbsvendor") do |dir|
  src = File.join(dir, "src")
  FileUtils.mkdir_p(File.join(src, "lib"))
  FileUtils.mkdir_p(File.join(src, "sig"))
  File.write(File.join(src, "lib", "g.rb"), "module G; end\n")
  File.write(File.join(src, "sig", "g.rbs"), "module G\nend\n")

  vend = Bundler::Spinel::Vendorer.allocate # skip initialize (no engine needed)
  into = File.join(dir, "vendor")
  dest = File.join(into, "g")
  vend.send(:place, src, dest)
  check(File.exist?(File.join(dest, "sig", "g.rbs")), "place copies sig/ alongside lib/")

  sig_root = File.join(into, "sig")
  check(vend.send(:collect_sig, dest, sig_root, "g"), "collect_sig reports a contribution")
  check(File.exist?(File.join(sig_root, "g", "g.rbs")), "aggregated under <into>/sig/g/")

  bare = File.join(into, "bare")
  FileUtils.mkdir_p(File.join(bare, "lib"))
  check(!vend.send(:collect_sig, bare, sig_root, "bare"), "no sig/ -> no contribution")

  # deps.rb advertises the single --rbs root only when someone contributed.
  vend.send(:write_manifest, into, [{ require: "g/lib/g", libdir: "g/lib" }], ["g"])
  deps = File.read(File.join(into, "deps.rb"))
  check(deps.include?("--rbs #{sig_root}"), "deps.rb header names the --rbs root")
  vend.send(:write_manifest, into, [{ require: "g/lib/g", libdir: "g/lib" }], [])
  check(!File.read(File.join(into, "deps.rb")).include?("--rbs"),
        "no sig gems -> no --rbs note")

  # spinel-flags: vendor emits the compile flags so the build auto-applies --rbs
  # (no per-consumer hand-wiring). Project-relative, empty when no sig roots.
  Dir.chdir(dir) do
    rel_into = "vendor"
    ff = vend.send(:write_compile_flags, rel_into, ["g"])
    flags = File.read(ff).strip
    check(flags == "--rbs vendor/sig", "spinel-flags carries project-relative --rbs (#{flags.inspect})")
    vend.send(:write_compile_flags, rel_into, [])
    check(File.read(ff).strip.empty?, "spinel-flags empty when no sig roots (cat-safe)")
  end
end

# --- Vendorer: committed-sibling drift guard (audit gap 1) -------------------
puts "\ndrift guard: a gem shipping lib/<X>/ + sig/<X>/ for an undeclared dep warns"
Dir.mktmpdir("rbssib") do |src|
  # a producer (like tep) that hand-copied a sibling gem (like spinel_kit)
  FileUtils.mkdir_p(File.join(src, "lib", "spinel_kit"))
  FileUtils.mkdir_p(File.join(src, "sig", "spinel_kit"))
  File.write(File.join(src, "lib", "spinel_kit", "json.rb"), "module SpinelKit; end\n")
  File.write(File.join(src, "sig", "spinel_kit", "json.rbs"), "module SpinelKit\nend\n")
  # the producer's own tree (must NOT trip the guard)
  FileUtils.mkdir_p(File.join(src, "lib", "tep"))
  FileUtils.mkdir_p(File.join(src, "sig", "tep"))

  vend = Bundler::Spinel::Vendorer.allocate
  Dep = Struct.new(:name) unless defined?(Dep)
  Spec = Struct.new(:name, :dependencies) unless defined?(Spec)

  # case A: spinel_kit NOT declared -> warns
  spec_a = Spec.new("tep", [])
  w = vend.send(:committed_sibling_warnings, src, spec_a)
  check(w.size == 1 && w.first.include?("hand-copied `spinel_kit`"),
        "undeclared committed sibling -> 1 warning about spinel_kit (#{w.inspect})")
  check(w.none? { |s| s.include?("hand-copied `tep`") }, "own namespace (tep) not flagged")

  # case B: spinel_kit declared as a dependency -> no warning (vendor manages it)
  spec_b = Spec.new("tep", [Dep.new("spinel_kit")])
  check(vend.send(:committed_sibling_warnings, src, spec_b).empty?,
        "declared dependency -> no warning")
end

# a gem with lib/<X>/ but NO matching sig/<X>/ is not the copy fingerprint
puts "\ndrift guard: lib-only sub-namespace (no sig/<X>/) is NOT flagged"
Dir.mktmpdir("rbssib2") do |src|
  FileUtils.mkdir_p(File.join(src, "lib", "helpers"))
  FileUtils.mkdir_p(File.join(src, "sig"))
  File.write(File.join(src, "lib", "helpers", "x.rb"), "module Helpers; end\n")
  vend = Bundler::Spinel::Vendorer.allocate
  spec = Struct.new(:name, :dependencies).new("mygem", [])
  check(vend.send(:committed_sibling_warnings, src, spec).empty?,
        "lib/<X>/ without sig/<X>/ -> no warning")
end

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
