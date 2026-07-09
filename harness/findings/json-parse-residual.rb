# Repro: two residual bugs in Spinel's bundled `json`, surfaced re-verifying the
# multi_json mirror after matz/spinel#1844 (JSON.parse now resolves) at engine
# git:bae3dbf2. JSON.generate/parse work for the common path; these two remain.
#
#   $ spinel harness/findings/json-parse-residual.rb -o /tmp/j.bin && /tmp/j.bin
#
# Part 1 — `symbolize_names:` is IGNORED (returns string keys):
#   Spinel: {"a" => 1}     CRuby: {a: 1}
#
# Part 2 — the ParserError raised INTERNALLY by JSON.parse is not caught by
# `rescue JSON::ParserError` at the call site, though e.class reports that name.
# It is NOT a general rescue bug: a custom error and an *explicitly* raised
# JSON::ParserError both catch correctly (controls below). So the parser's
# internal error class is not identical to the JSON::ParserError constant the
# caller sees — a dual-constant identity mismatch inside the bundled json package.
#   Spinel: escaped (e.class=JSON::ParserError)   CRuby: caught-by-class
require "json"

# Part 1
p JSON.parse('{"a":1}', symbolize_names: true)

# Part 2
r = begin
  JSON.parse("{bad}")
  "no-raise"
rescue JSON::ParserError
  "caught-by-class"
rescue => e
  "escaped:#{e.class}"
end
puts r

# Controls (both caught under Spinel — proving the bug is JSON.parse-internal):
class MyErr < StandardError; end
puts(begin; raise MyErr; rescue MyErr; "custom-caught"; end)
puts(begin; raise JSON::ParserError, "x"; rescue JSON::ParserError; "explicit-json-caught"; end)
