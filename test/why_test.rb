#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for the `why` report classifier (spinelgems#12): a Verdict's
# signals -> the right category + terminal/fixable judgement. Pure mapping,
# so a synthetic Verdict per signal class pins the behaviour. Run:
# `ruby test/why_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "stringio"
require "bundler/spinel"
require "bundler/spinel/why"

V = Bundler::Spinel::Ledger::Verdict
@fails = 0

def report_for(verdict:, reasons: [], risks: [])
  io = StringIO.new
  v = V.new(gem: "x", version: "1.0", rev: "rtest", verdict: verdict, reasons: reasons, risks: risks, probe: "p")
  Bundler::Spinel::Why.new(out: io).report(v)
  io.string
end

def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

# Each case: (label, verdict, reasons, risks) => [category substr, terminal substr]
cases = [
  ["C-ext static reject",     "rejected", ["c-extension"], [],
   ["native (C extension)", "TERMINAL"]],
  ["hard Thread/Mutex",       "rejected", ["hard:Mutex.new"], [],
   ["runtime construct", "improves when Spinel grows"]],
  ["rubric codegen",          "rejected", ["rubric:codegen", "out.c:12:5: error: foo"], [],
   ["compiler bug (codegen)", "FIXABLE"]],
  ["rubric miscompile",       "rejected", ["rubric:miscompile", "diff:L1 cruby=42 spinel=0"], [],
   ["silent miscompile", "FIXABLE"]],
  ["rubric load-path",        "rejected", ["rubric:load-path"], [],
   ["limitation (load path)", "improves when Spinel grows"]],
  ["rubric unsupported",      "rejected", ["rubric:unsupported", "unresolved:send", "unresolved:extend"], [],
   ["unsupported call", "FIXABLE"]],
  ["needs-dep only",          "rejected", ["needs:faraday"], [],
   ["dependency", "conditional"]],
  ["analyze-oom",             "rejected", ["analyze-oom: spinel_analyze OOM (matz/spinel#1302)"], [],
   ["analyzer OOM", "FIXABLE"]],
]

cases.each do |label, verdict, reasons, risks, (cat, term)|
  out = report_for(verdict: verdict, reasons: reasons, risks: risks)
  check(out.include?(cat),  "#{label}: category mentions #{cat.inspect}")
  check(out.include?(term), "#{label}: terminal line mentions #{term.inspect}")
end

# Positive verdicts explain themselves and point at the next rung.
%w[verified loaded clean].each do |verdict|
  out = report_for(verdict: verdict)
  check(out.include?(verdict), "#{verdict}: report names the verdict")
end
check(report_for(verdict: "loaded").include?("verify --smoke"), "loaded: suggests verify --smoke to graduate")

# unsupported evidence surfaces the actual unresolved calls.
out = report_for(verdict: "rejected", reasons: %w[rubric:unsupported unresolved:method_missing unresolved:define_method])
check(out.include?("method_missing"), "unsupported: lists the unresolved calls")

# A clean/risky gem with a dynamic risk gets a 'watch' note.
out = report_for(verdict: "risky", risks: ["define_method"])
check(out.include?("define_method"), "risky: surfaces the dynamic construct")

puts(@fails.zero? ? "\nALL PASS" : "\n#{@fails} FAILURE(S)")
exit(@fails.zero? ? 0 : 1)
