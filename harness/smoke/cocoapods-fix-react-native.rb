# smoke: cocoapods-fix-react-native
# Exercises CocoaPodsFixReactNative path-building logic and get_root helper.
# The gem's main entry point is a NOOP; real logic lives in fix_with_context.rb
# (requires molinillo) and the root_helper. We exercise version translation and
# filesystem path building — the core of the gem's version-dispatch logic.

# Locate molinillo in the gem cache so fix_with_context.rb can load it.
gem_cache = File.expand_path('~/.cache/spinel-compat/gems')
molinillo_dir = Dir.entries(gem_cache)
                   .select { |e| e.start_with?('molinillo-') }
                   .sort.last
$LOAD_PATH.unshift(File.join(gem_cache, molinillo_dir, 'lib')) if molinillo_dir

require 'cocoapods-fix-react-native'

GEM_LIB = File.join(gem_cache,
  Dir.entries(gem_cache)
    .select { |e| e.start_with?('cocoapods-fix-react-native-') }
    .sort.last,
  'lib')

# Load fix_with_context.rb — defines CocoaPodsFixReactNative with private
# version_file / versions_path helpers. The class uses patch_exist? which
# calls Array#present? (ActiveSupport), so we only call the pure path helpers.
load File.join(GEM_LIB, 'cocoapods-fix-react-native', 'fix_with_context.rb')

fixer = CocoaPodsFixReactNative.new

# versions_path points to the gem's versions/ directory
vp = fixer.send(:versions_path)
puts "versions_path ends with /versions: #{vp.end_with?('/versions')}"
puts "versions_path is absolute: #{vp.start_with?('/')}"

# version_file translates a version string to a patch filename
# dots replaced with underscores, suffix appended
vf_post = fixer.send(:version_file, '0.59.10', 'post')
puts "version_file(0.59.10, post): #{File.basename(vf_post)}"

vf_pre = fixer.send(:version_file, '0.57.3', 'pre')
puts "version_file(0.57.3, pre): #{File.basename(vf_pre)}"

vf_default = fixer.send(:version_file, '0.53.3')
puts "version_file(0.53.3) default suffix: #{File.basename(vf_default)}"

# Known post-patches exist in the gem
puts "0.59.10-post exists: #{File.exist?(vf_post)}"
puts "0.57.3-pre exists: #{File.exist?(vf_pre)}"

# A made-up version has no patch file
vf_fake = fixer.send(:version_file, '9.99.0', 'post')
puts "9.99.0-post exists: #{File.exist?(vf_fake)}"

# Count how many version patch files ship with the gem
patches = Dir.glob(File.join(vp, '*-post.rb'))
puts "post-patch count >= 20: #{patches.size >= 20}"

# get_root helper: env override takes priority
ENV["COCOAPODS_FIX_REACT_NATIVE_DEV_ROOT"] = "/tmp/fake-rn"
load File.join(GEM_LIB, 'cocoapods-fix-react-native', 'helpers', 'root_helper.rb')
puts "get_root with env override: #{get_root}"

# Without env override and no node_modules around, falls back to 'Pods/React'
ENV.delete("COCOAPODS_FIX_REACT_NATIVE_DEV_ROOT")
$root = nil
puts "get_root default (no node_modules): #{get_root}"
