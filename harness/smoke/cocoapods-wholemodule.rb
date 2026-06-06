# Smoke for cocoapods-wholemodule 0.0.1
# The gem's main entry point only loads gem_version.rb (CocoaPodsWholeModule::VERSION).
# The actual plugin logic in post_install.rb requires cocoapods-core (unavailable),
# so we stub the require and mock the minimal CocoaPods hook infrastructure
# to exercise the real wholemodule config-selection logic.

module Kernel
  alias_method :orig_require, :require
  def require(path)
    return true if path == 'cocoapods-core'
    orig_require(path)
  end
end

module Pod
  module HooksManager
    @hooks = {}
    def self.register(name, hook, &block)
      @hooks[hook] ||= {}
      @hooks[hook][name] = block
    end
    def self.hooks; @hooks; end
  end
end

require 'cocoapods-wholemodule'

# Load post_install.rb from the gem's lib dir (not auto-loaded by the gem itself)
_gem_lib = $LOAD_PATH.find { |p| File.exist?(File.join(p, 'cocoapods-wholemodule/post_install.rb')) }
raise 'Cannot locate cocoapods-wholemodule/post_install.rb in load path' unless _gem_lib
load File.join(_gem_lib, 'cocoapods-wholemodule/post_install.rb')

# Minimal mock of the CocoaPods project/target/build-config hierarchy
BuildConfig = Struct.new(:name, :build_settings) do
  def initialize(name); super(name, {}); end
end

Target = Struct.new(:name, :build_configurations)

Project = Struct.new(:targets) do
  def save; end  # no-op — we don't write Xcode files
end

InstallerStub = Struct.new(:pods_project)

def make_installer(target_configs)
  targets = target_configs.each_with_index.map do |(tname, cfg_names), _i|
    Target.new(tname, cfg_names.map { |n| BuildConfig.new(n) })
  end
  InstallerStub.new(Project.new(targets))
end

hook = Pod::HooksManager.hooks[:post_install]['cocoapods-wholemodule']

# --- Test 1: default options — Release gets -Owholemodule, Debug gets -Onone ---
inst1 = make_installer([['PodA', %w[Debug Release]], ['PodB', %w[Debug Release]]])
hook.call(inst1, {})
puts "default:"
inst1.pods_project.targets.each do |t|
  t.build_configurations.each do |c|
    puts "  #{t.name}/#{c.name}=#{c.build_settings['SWIFT_OPTIMIZATION_LEVEL']}"
  end
end

# --- Test 2: custom String config ---
inst2 = make_installer([['PodC', %w[Debug CustomRelease]]])
hook.call(inst2, { wholemodule: 'CustomRelease' })
puts "string option:"
inst2.pods_project.targets.each do |t|
  t.build_configurations.each do |c|
    puts "  #{t.name}/#{c.name}=#{c.build_settings['SWIFT_OPTIMIZATION_LEVEL']}"
  end
end

# --- Test 3: custom Array of configs ---
inst3 = make_installer([['PodD', %w[Debug Staging Production]]])
hook.call(inst3, { wholemodule: %w[Staging Production] })
puts "array option:"
inst3.pods_project.targets.each do |t|
  t.build_configurations.each do |c|
    puts "  #{t.name}/#{c.name}=#{c.build_settings['SWIFT_OPTIMIZATION_LEVEL']}"
  end
end

puts "version: #{CocoaPodsWholeModule::VERSION}"
