#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for Probe verdict classification, focused on the b60fbd7
# require-hard-fail absorption: an unresolvable plain `require` now makes
# `spinel -c` exit non-zero (it used to warn + continue), which spuriously
# turned ~thousands of `clean` gems into `analyze-failed`. A require-ONLY
# compile failure must classify as the load-path limit (risky), while a real
# codegen error still rejects. Hermetic: a fake `spinel` whose output/exit we
# script per gem. Run: `ruby test/probe_classify_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

# A fake engine dir: a `spinel` script that prints $SPINEL_FAKE_OUT and exits
# $SPINEL_FAKE_RC, plus a .spinel_rev so rev is stable.
def fake_engine(out, rc)
  dir = Dir.mktmpdir("probe-eng")
  File.write(File.join(dir, ".spinel_rev"), "testrev\n")
  # Exact bytes via a file (backticks in the output would be command-substituted
  # if interpolated into a double-quoted printf), cat'd to stderr.
  File.write(File.join(dir, "fake_out.txt"), out + "\n")
  File.write(File.join(dir, "spinel"), <<~SH)
    #!/bin/sh
    cat "$(dirname "$0")/fake_out.txt" >&2
    exit #{rc}
  SH
  File.chmod(0o755, File.join(dir, "spinel"))
  dir
end

def gem_dir(name)
  dir = Dir.mktmpdir("probe-gem")
  FileUtils.mkdir_p(File.join(dir, "lib"))
  File.write(File.join(dir, "lib", "#{name}.rb"), "module X; end\n")
  dir
end

def verdict_for(engine_out, rc, gem: "g")
  eng = fake_engine(engine_out, rc)
  gd = gem_dir(gem)
  led = File.join(Dir.mktmpdir("probe-led"), "l.jsonl")
  engine = Bundler::Spinel::Engine.new(dir: eng)
  ledger = Bundler::Spinel::Ledger.new(path: led)
  Bundler::Spinel::Probe.new(engine, ledger).probe(gem, "1.0", gd)
  require "json"
  JSON.parse(File.readlines(led).last)
end

puts "require-only compile failure -> risky (load-path:require), not analyze-failed"
v = verdict_for("spinel: unsupported call: node 10 (CallNode `require`) recv=-/ty-1 argc=1 arg0ty6", 1)
check(v["verdict"] == "risky", "verdict risky (got #{v["verdict"]})")
check((v["reasons"] || []).include?("load-path:require"), "reason load-path:require (#{(v["reasons"]||[]).inspect})")

puts "\nreal codegen error -> rejected analyze-failed"
v = verdict_for("/tmp/out.c:42:5: error: incompatible type for argument 1 of 'sp_box_int'", 1)
check(v["verdict"] == "rejected", "verdict rejected (got #{v["verdict"]})")
check((v["reasons"] || []).include?("analyze-failed"), "reason analyze-failed")

puts "\nrequire fail + a real error -> rejected (hard error wins)"
v = verdict_for("unsupported call: node 10 (CallNode `require`)\\n/tmp/out.c:9:1: error: boom", 1)
check(v["verdict"] == "rejected", "mixed -> rejected (got #{v["verdict"]})")

puts "\nunsupported non-require call -> rejected (not reclassified as load-path)"
v = verdict_for("spinel: unsupported puts argument: node 3 (CallNode `escape`) recv=ConstantReadNode", 1)
check(v["verdict"] == "rejected", "non-require unsupported -> rejected (got #{v["verdict"]})")

puts "\nclean compile (exit 0, no diagnostics) -> clean"
v = verdict_for("", 0)
check(v["verdict"] == "clean", "clean (got #{v["verdict"]})")

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
