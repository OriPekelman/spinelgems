# Smoke test for capistrano-multiconfig
# Exercises Capistrano::Multiconfig::DSL#stages and #stages_root
# which are the core public API for multi-stage configuration discovery.
#
# The main capistrano/multiconfig.rb requires capistrano + rake at runtime,
# but the DSL module is self-contained and testable standalone.

require 'capistrano/multiconfig/dsl'

# Minimal host object implementing Capistrano's fetch() interface
class MultiConfigTester
  include Capistrano::Multiconfig::DSL

  def initialize(root)
    @root = root
  end

  def fetch(key, default = nil)
    case key
    when :stages_root then @root
    else default
    end
  end
end

# Locate the gem's fixture directory. We resolve via Gem.find_files or a known
# relative path from the gem's lib dir (lib is always on $LOAD_PATH).
GEM_LIB = $LOAD_PATH.find { |p| File.exist?(File.join(p, 'capistrano/multiconfig/dsl.rb')) }
GEM_FIXTURES = File.expand_path('../fixtures/config', GEM_LIB)

# --- 1. Simple two-file flat layout ---
t = MultiConfigTester.new("#{GEM_FIXTURES}/two_files")
puts "stages_root: #{t.stages_root}"
puts "two_files stages: #{t.stages.inspect}"

# --- 2. Third-level nested (three-component stage names) ---
t2 = MultiConfigTester.new("#{GEM_FIXTURES}/third_level_nested")
puts "third_level_nested stages: #{t2.stages.inspect}"

# --- 3. Two nested apps (four stages total) ---
t3 = MultiConfigTester.new("#{GEM_FIXTURES}/two_nested")
puts "two_nested stages: #{t3.stages.inspect}"

# --- 4. Path construction logic: stage name -> config file paths ---
# Mirrors the inject block in capistrano/multiconfig.rb lines 43-45
stage = 'app:blog:production'
root  = "#{GEM_FIXTURES}/third_level_nested"
paths = stage.split(':').inject([root]) { |acc, seg| acc << File.join(acc.last, seg) }
# Strip the fixtures prefix so output is deterministic across machines
relative = paths.map { |p| p.sub(GEM_FIXTURES + '/', '') }
puts "path segments for '#{stage}': #{relative.inspect}"

# --- 5. Stage-name derivation from file paths (tr logic) ---
files = [
  'soa/blog/production.rb',
  'soa/wiki/qa.rb',
  'app/staging.rb',
]
files.each do |f|
  # slice off the leading root + '/' and trailing '.rb'
  name = f.slice(0..-4).tr('/', ':')
  puts "file_to_stage '#{f}' => '#{name}'"
end

# --- 6. Shared-file filtering: parent paths excluded when children exist ---
t4 = MultiConfigTester.new("#{GEM_FIXTURES}/nested_with_shared_file")
puts "nested_with_shared_file stages: #{t4.stages.inspect}"
