# Smoke: md_splitter
# Tests MdSplitter::Splitter constants, instantiation, and dry-run split.
# Deps (Kramdown/uuidtools/active_support) are plain requires that Spinel
# ignores; stubs live in the gem's lib/ so CRuby resolves them too.

require 'md_splitter'
require 'md_splitter/splitter'

# 1. Version constant
puts MdSplitter::VERSION

# 2. Class-level string constants
puts MdSplitter::Splitter::LIVE_PREFIX
puts MdSplitter::Splitter::DRY_RUN_PREFIX

# 3. Default options hash
defaults = MdSplitter::Splitter::DEFAULTS
puts defaults[:dry_run].inspect
puts defaults[:split_on].inspect

# 4. Instantiation
splitter = MdSplitter::Splitter.new
puts splitter.class

# 5. dry_run split — exercises convert path, writes nothing to disk
md_file = '/tmp/md_splitter_smoke_input.md'
File.write(md_file, "# Hello World\n\nThis is a test paragraph.")
splitter.split(md_file, dry_run: true)

# 6. dry_run split with split_on — exercises the multi-page path
splitter2 = MdSplitter::Splitter.new
splitter2.split(md_file, dry_run: true, split_on: "---")
