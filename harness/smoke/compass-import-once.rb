require 'compass-import-once'
require 'set'

# --- VERSION ---
puts Compass::ImportOnce::VERSION

# --- import_tracker: Thread-local Hash ---
tracker = Compass::ImportOnce.import_tracker
puts tracker.class
puts tracker.empty?

# Populate tracker and verify retrieval
Compass::ImportOnce.import_tracker['output.css'] = Set.new(['key1', 'key2'])
puts Compass::ImportOnce.import_tracker['output.css'].include?('key1')
puts Compass::ImportOnce.import_tracker['output.css'].size

# --- Importer module: handle_force_import ---
# Base importer provides a fallback key method
class BaseImporter
  def key(uri, options, *args)
    [uri, 'base']
  end
end

class MyImporter < BaseImporter
  include Compass::ImportOnce::Importer
end

imp = MyImporter.new

# Force import: URI ending with '!' strips the bang and sets forced=true
uri, forced = imp.send(:handle_force_import, 'mixins.scss!')
puts uri
puts forced

# Normal import: no bang
uri2, forced2 = imp.send(:handle_force_import, 'variables.scss')
puts uri2
puts forced2

# --- Importer#key: NOT IMPORTED pattern ---
# When uri matches '(NOT IMPORTED) <path>', return the import-once key
result = imp.key('(NOT IMPORTED) /path/to/style.scss', {})
puts result.inspect

# Normal URI falls through to super (BaseImporter)
result2 = imp.key('normal.scss', {})
puts result2.inspect

# --- normalize_filesystem_importers: replaces Glob: prefix ---
normalized = imp.send(:normalize_filesystem_importers, [
  'Glob:/assets/sass',
  'Sass::Importers::Filesystem:/vendor'
])
puts normalized.inspect

# --- Engine module: with_import_scope lifecycle ---
class FakeEngine
  include Compass::ImportOnce::Engine

  def options
    { css_filename: 'app.css' }
  end

  def render
    'body { color: red; }'
  end
end

eng = FakeEngine.new

# Tracker has no entry before scope
puts Compass::ImportOnce.import_tracker.key?('app.css')

# Inside scope: entry exists and is a Set
eng.with_import_scope('app.css') do
  puts Compass::ImportOnce.import_tracker.key?('app.css')
  puts Compass::ImportOnce.import_tracker['app.css'].class
end

# Entry cleaned up after scope (ensure block runs)
puts Compass::ImportOnce.import_tracker.key?('app.css')

# --- Engine#render wraps with_import_scope ---
# The render override sets up and tears down the scope automatically
output = eng.render
puts output
