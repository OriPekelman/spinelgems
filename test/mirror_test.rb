#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for Mirror — the mirror-package scaffolder (matz/spinel#1753 porter
# tool). Locks the seeded exclusion ledger (probe reasons/risks -> ledger rows),
# the const-name derivation, and that the scaffold emits a coherent spin-package
# tree whose generated Ruby actually loads/runs under CRuby. Hermetic: writes to
# a tmpdir, no compiler. Run: `ruby test/mirror_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "tmpdir"
require "shellwords"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

M = Bundler::Spinel::Mirror

# --- const_name ---
puts "const_name"
check(M.const_name("redis") == "Redis", "redis -> Redis")
check(M.const_name("http-cookie") == "HttpCookie", "dashed -> CamelCase")
check(M.const_name("active_support") == "ActiveSupport", "underscored -> CamelCase")

# --- seeded_exclusions: reasons then risks, known + unknown tokens ---
puts "\nseeded_exclusions"
rec = { "verdict" => "risky", "reasons" => ["c-extension"],
        "risks" => ["method_missing", "eval", "send", "weirdtoken"] }
ex = M.seeded_exclusions(rec)
check(ex[0][0] == "c-extension" && ex[0][1] == "reimplement", "reason c-extension first, reimplement")
check(ex.map { |r| r[0] } == %w[c-extension method_missing eval send weirdtoken], "order: reasons then risks")
check(ex.find { |r| r[0] == "method_missing" }[1] == "reimplement", "method_missing -> reimplement")
check(ex.find { |r| r[0] == "eval" }[1] == "exclude", "eval -> exclude")
check(ex.find { |r| r[0] == "send" }[1] == "narrow", "send -> narrow")
check(ex.find { |r| r[0] == "weirdtoken" }[1] == "review", "unknown token -> review (nothing dropped)")
# colon-tagged tokens key on the head (e.g. "unsupported:foo" -> "unsupported")
check(M.seeded_exclusions({ "risks" => ["method_missing:bar"] })[0][1] == "reimplement",
      "colon-tagged token keys on head")
check(M.seeded_exclusions(nil).empty?, "nil record -> no rows")

# --- scaffold: full tree, seeded README, runnable generated code ---
puts "\nscaffold"
Dir.mktmpdir("mirror") do |root|
  res = M.scaffold(name: "redis", version: "0.1.0", gem_version: "5.4.1",
                   record: rec, engine_rev: "git:abc123/aarch64-linux",
                   out: File.join(root, "spinel-redis"))
  d = res[:dir]
  %w[spin.toml redis.rb redis/core.rb README.md oracle/run.sh oracle/smoke.rb
     test/redis_test.rb test/smoke_test.rb.expected examples/basic.rb bin/verify
     .gitignore].each do |f|
    check(File.exist?(File.join(d, f)), "emitted #{f}")
  end
  check(res[:exclusions].size == 5, "5 exclusions returned")

  # spin.toml: package name claims the require string, no prefix
  toml = File.read(File.join(d, "spin.toml"))
  check(toml.include?(%(name = "redis")) && !toml.include?("spinel-redis\""), "spin.toml name = redis")

  # README carries the seeded ledger table + the 3 conditions + provenance
  readme = File.read(File.join(d, "README.md"))
  check(readme.include?("| `method_missing` | reimplement |"), "README ledger row rendered")
  check(readme.include?("condition #3") || readme.include?("fails loudly") || readme.include?("Out-of-ledger"), "README states loud-failure condition")
  check(readme.include?("redis 5.4.1") && readme.include?("`risky`"), "README provenance from probe")

  # oracle/run.sh + bin/verify are executable
  check(File.stat(File.join(d, "oracle/run.sh")).mode & 0o111 != 0, "oracle/run.sh executable")
  check(File.stat(File.join(d, "bin/verify")).mode & 0o111 != 0, "bin/verify executable")

  # the generated dual-runtime test loads the core and runs under CRuby
  out = `cd #{d.shellescape} && ruby test/redis_test.rb 2>&1`
  check($?.success? && out.include?("version true"), "generated test runs under CRuby (#{out.strip.inspect})")

  # loud-failure doctrine present, no method_missing funnel generated
  core = File.read(File.join(d, "redis/core.rb"))
  root_rb = File.read(File.join(d, "redis.rb"))
  check(!core.include?("method_missing") && !root_rb.downcase.include?("def method_missing"), "no method_missing funnel emitted")
end

# --- empty-dir guard ---
puts "\nguard"
Dir.mktmpdir("mirror2") do |root|
  dir = File.join(root, "pkg")
  Dir.mkdir(dir); File.write(File.join(dir, "keep"), "x")
  begin
    M.scaffold(name: "x", out: dir)
    check(false, "non-empty dir should raise")
  rescue Bundler::Spinel::Error
    check(true, "refuses a non-empty dir without --force")
  end
  M.scaffold(name: "x", out: dir, force: true)
  check(File.exist?(File.join(dir, "spin.toml")), "--force writes into non-empty dir")
end

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
