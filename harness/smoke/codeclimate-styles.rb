require 'codeclimate-styles'

# CC::Styles is a Rails asset-pipeline gem; its Ruby surface is thin:
# VERSION constant + assets_dir path helper.

# 1. VERSION is a frozen string constant
puts CC::Styles::VERSION
puts CC::Styles::VERSION.frozen? ? 'version frozen' : 'version not frozen'

# 2. assets_dir builds a path relative to the gem's own __FILE__
dir = CC::Styles.assets_dir
# The returned path must always end with /assets regardless of install location
puts dir.end_with?('/assets') ? 'assets_dir ends with assets' : "unexpected suffix: #{dir}"
# Must be an absolute (non-empty) path
puts dir.start_with?('/') ? 'assets_dir is absolute' : 'assets_dir not absolute'

# 3. assets_dir is deterministic across calls
puts CC::Styles.assets_dir == dir ? 'assets_dir stable' : 'assets_dir unstable'
