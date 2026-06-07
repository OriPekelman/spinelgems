# Smoke test for kitchenplan 2.1.18
# kitchenplan is a workstation provisioning tool (chef-solo wrapper).
# Its core is Kitchenplan::Config which merges YAML recipe/attribute hashes
# from default, group, people, and system config files.
#
# deep_merge is a runtime dep not bundled with Spinel; we intercept its
# require via a Kernel.require alias so CRuby is happy and Spinel (which
# ignores external requires) is unaffected.

module Kernel
  alias_method :_kp_orig_require, :require
  def require(name)
    if name == 'deep_merge'
      unless defined?(DeepMerge)
        Object.const_set(:DeepMerge, Module.new)
        Hash.class_eval do
          def deep_merge!(other, _opts = {}, &block)
            other.each do |k, v|
              if self[k].is_a?(Hash) && v.is_a?(Hash)
                self[k].deep_merge!(v, &block)
              elsif block_given? && key?(k)
                self[k] = block.call(k, self[k], v)
              else
                self[k] = v
              end
            end
            self
          end
        end
      end
      true
    else
      _kp_orig_require(name)
    end
  end
end

# Array.wrap is an ActiveSupport helper used in Config#config merge blocks
class Array
  def self.wrap(obj)
    obj.nil? ? [] : (obj.respond_to?(:to_ary) ? (obj.to_ary || [obj]) : [obj])
  end
end

require 'kitchenplan'
require 'kitchenplan/config'

# --- Test 1: hash_path private helper ---
# Navigates a nested hash via a path of keys; returns nil for missing paths.
cfg = Kitchenplan::Config.allocate
cfg.instance_variable_set(:@platform, 'mac_os_x')
cfg.instance_variable_set(:@default_config, {})
cfg.instance_variable_set(:@people_config, {})
cfg.instance_variable_set(:@system_config, {})
cfg.instance_variable_set(:@group_configs, {})

h = { 'recipes' => { 'global' => %w[recipe1 recipe2], 'mac_os_x' => ['recipe3'] } }
puts cfg.send(:hash_path, h, 'recipes', 'global').inspect   # => ["recipe1", "recipe2"]
puts cfg.send(:hash_path, h, 'recipes', 'missing').inspect  # => nil
puts cfg.send(:hash_path, h, 'nonexistent', 'key').inspect  # => nil

# --- Test 2: Config#config recipe and attribute merging ---
# Recipes from default, groups, and people are union-merged (no duplicates).
# Attributes are deep-merged with later sources overriding/extending earlier.
cfg2 = Kitchenplan::Config.allocate
cfg2.instance_variable_set(:@platform, 'mac_os_x')
cfg2.instance_variable_set(:@default_config, {
  'recipes'    => { 'global' => ['recipe::default'], 'mac_os_x' => ['mac::thing'] },
  'attributes' => { 'packages' => ['vim', 'git'], 'editor' => 'nano' }
})
cfg2.instance_variable_set(:@people_config, {
  'recipes'    => { 'global' => ['personal::setup'] },
  'attributes' => { 'packages' => ['zsh'] }
})
cfg2.instance_variable_set(:@system_config, {})
cfg2.instance_variable_set(:@group_configs, {
  'dev' => {
    'recipes'    => { 'global' => ['dev::tools'], 'mac_os_x' => ['mac::dev'] },
    'attributes' => { 'packages' => ['tmux'] }
  }
})

result = cfg2.config
puts result['recipes'].sort.inspect
# => ["dev::tools", "mac::dev", "mac::thing", "personal::setup", "recipe::default"]
puts result['attributes']['packages'].sort.inspect  # => ["git", "tmux", "vim", "zsh"]
puts result['attributes']['editor'].inspect         # => "nano"

# --- Test 3: detect_platform always returns mac_os_x ---
cfg3 = Kitchenplan::Config.allocate
cfg3.instance_variable_set(:@platform, nil)
cfg3.detect_platform
puts cfg3.platform.inspect  # => "mac_os_x"

# --- Test 4: empty config produces empty recipes and attributes ---
cfg4 = Kitchenplan::Config.allocate
cfg4.instance_variable_set(:@platform, 'mac_os_x')
cfg4.instance_variable_set(:@default_config, {})
cfg4.instance_variable_set(:@people_config, {})
cfg4.instance_variable_set(:@system_config, {})
cfg4.instance_variable_set(:@group_configs, {})
empty = cfg4.config
puts empty['recipes'].inspect    # => []
puts empty['attributes'].inspect # => {}
