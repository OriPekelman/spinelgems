#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for transitive gem->gem vendoring (spinelgems#19): the deps.rb a
# consumer require_relatives must load every gem's dependencies BEFORE it
# (topo order, gap 1), and a dependent's plain `require "<dep>"` must resolve
# under CRuby too (the $LOAD_PATH prelude, gap 2). Hermetic — synthetic specs
# for the ordering logic + the committed two-gem fixture for a real load. Run:
# `ruby test/transitive_vendor_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

V = Bundler::Spinel::Vendorer.new

# A spec double: name + runtime dependency names (Gem::Dependency-shaped).
Dep  = Struct.new(:name)
Spec = Struct.new(:name, :version, :dependencies)
def spec(name, *deps) = Spec.new(name, "1.0", deps.map { |d| Dep.new(d) })

# --- gap 1: topological order, dependencies before dependents ---------------
puts "topo_sort orders dependencies before dependents"
specs = [spec("aa_consumer", "zz_provider"), spec("zz_provider")] # alphabetical is WRONG
order = V.send(:topo_sort, specs).map(&:name)
check(order.index("zz_provider") < order.index("aa_consumer"),
      "zz_provider before aa_consumer (got #{order.inspect})")

# a diamond: app -> {http, json}; http -> json. json must precede both.
diamond = [spec("app", "http", "json"), spec("http", "json"), spec("json")]
do_ = V.send(:topo_sort, diamond).map(&:name)
check(do_.index("json") < do_.index("http") && do_.index("http") < do_.index("app"),
      "diamond json<http<app (got #{do_.inspect})")

# a cycle degrades to *some* stable order without looping (no infinite recursion).
cyclic = [spec("x", "y"), spec("y", "x")]
begin
  co = V.send(:topo_sort, cyclic).map(&:name)
  check(co.sort == %w[x y], "cycle x<->y terminates with both present (got #{co.inspect})")
rescue SystemStackError
  check(false, "cycle caused infinite recursion")
end

# deps not in the lockset (stdlib/default gems) are simply skipped.
withext = [spec("solo", "json", "set")] # json/set absent from the set
so = V.send(:topo_sort, withext).map(&:name)
check(so == %w[solo], "absent deps skipped (got #{so.inspect})")

# --- gap 2: deps.rb prelude + require order ---------------------------------
puts "\nwrite_manifest emits $LOAD_PATH prelude + topo require_relative order"
Dir.mktmpdir("transitive") do |into|
  entries = [
    { require: "zz_provider/lib/zz_provider", libdir: "zz_provider/lib" },
    { require: "aa_consumer/lib/aa_consumer", libdir: "aa_consumer/lib" },
  ]
  V.send(:write_manifest, into, entries)
  deps = File.read(File.join(into, "deps.rb"))
  check(deps.include?(%($LOAD_PATH.unshift(File.expand_path("zz_provider/lib", __dir__)))),
        "$LOAD_PATH prelude for the provider lib")
  check(deps.index("zz_provider/lib/zz_provider") < deps.index("aa_consumer/lib/aa_consumer"),
        "require_relative order preserves topo order")
  check(deps.index("$LOAD_PATH") < deps.index(%(require_relative ")),
        "$LOAD_PATH prelude precedes the require_relative directives")
end

# --- require_target: nested-entry gems (rspec-core shape) -------------------
# A dashed gem often ships only lib/<a>/<b>.rb (rspec-core -> lib/rspec/core.rb),
# no top-level lib/<a>-<b>.rb. It must still resolve to that entry (dash->slash),
# and a gem with NO resolvable entry must still land on $LOAD_PATH so a
# dependent's plain `require` finds it.
puts "\nrequire_target resolves dash->slash entry; libdir always on $LOAD_PATH"
Dir.mktmpdir("reqtarget") do |dir|
  # top-level lib/diff-lcs.rb wins
  FileUtils.mkdir_p(File.join(dir, "diff-lcs", "lib", "diff"))
  File.write(File.join(dir, "diff-lcs", "lib", "diff-lcs.rb"), "require 'diff/lcs'\n")
  File.write(File.join(dir, "diff-lcs", "lib", "diff", "lcs.rb"), "module Diff; end\n")
  check(V.send(:require_target, "diff-lcs", File.join(dir, "diff-lcs")) == "diff-lcs/lib/diff-lcs",
        "top-level lib/<name>.rb preferred")

  # nested-only lib/rspec/core.rb -> dash->slash
  FileUtils.mkdir_p(File.join(dir, "rspec-core", "lib", "rspec"))
  File.write(File.join(dir, "rspec-core", "lib", "rspec", "core.rb"), "module RSpec; end\n")
  check(V.send(:require_target, "rspec-core", File.join(dir, "rspec-core")) == "rspec-core/lib/rspec/core",
        "dash->slash entry when no top-level file")

  # no resolvable entry (only deeply nested) -> nil, but still gets a libdir
  FileUtils.mkdir_p(File.join(dir, "weird", "lib", "a", "b"))
  File.write(File.join(dir, "weird", "lib", "a", "b", "c.rb"), "module X; end\n")
  check(V.send(:require_target, "weird", File.join(dir, "weird")).nil?, "no entry -> nil")

  # write_manifest: a libdir-only entry (require: nil) still unshifts $LOAD_PATH,
  # emits no require_relative.
  Dir.mktmpdir("manifest-nil") do |into|
    V.send(:write_manifest, into,
           [{ require: nil, libdir: "weird/lib" },
            { require: "rspec-core/lib/rspec/core", libdir: "rspec-core/lib" }])
    deps = File.read(File.join(into, "deps.rb"))
    check(deps.include?(%($LOAD_PATH.unshift(File.expand_path("weird/lib", __dir__)))),
          "nil-require gem still on $LOAD_PATH")
    check(!deps.include?("require_relative \"\"") && !deps.match?(/require_relative\s*$/),
          "nil-require gem emits no require_relative")
    check(deps.include?(%(require_relative "rspec-core/lib/rspec/core")),
          "entry gem still require_relative'd")
  end
end

# --- gaps 1+2 end-to-end: the real fixture loads through a generated deps.rb -
puts "\nthe two-gem fixture loads (provider's constant visible to the consumer)"
fixture = File.expand_path("fixtures/transitive", __dir__)
Dir.mktmpdir("transitive-e2e") do |into|
  # Place both gems' libs as `vendor` would, then build deps.rb via the real
  # method and require it. aa_consumer references ZzProvider::VALUE at load
  # time, so a wrong order or a missing $LOAD_PATH entry raises here.
  %w[zz_provider aa_consumer].each do |g|
    FileUtils.mkdir_p(File.join(into, g))
    FileUtils.cp_r(File.join(fixture, g, "lib"), File.join(into, g, "lib"))
  end
  entries = [
    { require: "zz_provider/lib/zz_provider", libdir: "zz_provider/lib" },
    { require: "aa_consumer/lib/aa_consumer", libdir: "aa_consumer/lib" },
  ]
  V.send(:write_manifest, into, entries)
  out = `ruby -e 'require_relative #{File.join(into, "deps").inspect}; print AaConsumer.report' 2>&1`
  check(out == "consumer sees 84", "fixture loads under CRuby via deps.rb (got #{out.inspect})")
end

puts(@fails.zero? ? "\nALL PASS" : "\n#{@fails} FAILURE(S)")
exit(@fails.zero? ? 0 : 1)
