# Smoke for junit_merge 0.1.2
# Stubs nokogiri so app.rb loads, then exercises SummaryDiff
# (merge-accounting struct) and attribute_predicate (XPath string escaping).

# Intercept 'nokogiri' before it hits rubygems
$LOADED_FEATURES << 'nokogiri'
module Nokogiri; end

require 'junit_merge'

# Trigger autoload of App (nokogiri stub already in $LOADED_FEATURES)
app = JunitMerge::App.new

# ── SummaryDiff ────────────────────────────────────────────────────────────
SD = JunitMerge::App::SummaryDiff

# Minimal node stub matching the xpath/[] interface App expects
NodeStub = Struct.new(:attrs, :children) do
  def xpath(path)
    tag = path.tr('/', '')
    children.select { |c| c == tag }
  end
  def [](k); attrs[k]; end
  def []=(k, v); attrs[k] = v; end
end

# 1. One passing test added
sd = SD.new
passing = NodeStub.new({'classname' => 'Foo', 'name' => 'test_ok'}, [])
sd.add(passing, 1)
puts "tests=#{sd.tests} failures=#{sd.failures} errors=#{sd.errors} skipped=#{sd.skipped}"

# 2. One failing test added
sd2 = SD.new
failing = NodeStub.new({'classname' => 'Bar', 'name' => 'test_fail'}, ['failure'])
sd2.add(failing, 1)
puts "tests=#{sd2.tests} failures=#{sd2.failures} errors=#{sd2.errors} skipped=#{sd2.skipped}"

# 3. Net zero (add then remove same node)
sd3 = SD.new
sd3.add(failing, 1)
sd3.add(failing, -1)
puts "tests=#{sd3.tests} failures=#{sd3.failures} errors=#{sd3.errors} skipped=#{sd3.skipped}"

# 4. apply_to propagates delta to a suite node's attributes
suite = NodeStub.new({'tests' => '5', 'failures' => '1', 'errors' => '0', 'skipped' => '0'}, [])
sd4 = SD.new
sd4.add(passing, 1)
sd4.apply_to(suite)
puts "suite tests=#{suite['tests']} failures=#{suite['failures']}"

# ── attribute_predicate ────────────────────────────────────────────────────
pred_simple = app.send(:attribute_predicate, 'classname', 'com.example.Foo')
pred_quoted = app.send(:attribute_predicate, 'name', 'it\'s a "test"')
puts pred_simple
puts pred_quoted

# ── VERSION ───────────────────────────────────────────────────────────────
puts JunitMerge::VERSION.to_s
