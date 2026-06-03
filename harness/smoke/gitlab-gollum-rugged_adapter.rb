# Smoke: gitlab-gollum-rugged_adapter
# Exercises Actor (name/email/output/to_h/default_actor), Index treemap
# (pure-Ruby path-splitting logic), constants, and NoSuchShaFound error class.
#
# BEGIN stubs rugged/ostruct/mime-types before any require_relative runs —
# including the ones the --full harness prepends before this body — so CRuby
# can load the file without the native rugged extension.
# Spinel ignores plain `require` to other gems automatically.

BEGIN {
  module Rugged; end unless defined?(Rugged)
  module Kernel
    alias_method :_orig_require_gollum_smoke, :require
    def require(name)
      return true if name == 'rugged' || name == 'ostruct' || name =~ /\Amime/i
      _orig_require_gollum_smoke(name)
    end
  end
}

require 'rugged_adapter'

# --- Actor: name, email, output, to_h ---
actor = Gollum::Git::Actor.new('Alice Smith', 'alice@example.com')
puts actor.name
puts actor.email
puts actor.to_h.inspect

# Pin to a fixed UTC timestamp for determinism (utc_offset = 0)
t = Time.at(1700000000).utc
puts actor.output(t)

# default_actor
puts Gollum::Git::Actor.default_actor.name

# --- Constants and error class ---
puts Gollum::Git::DEFAULT_MIME_TYPE
err = Gollum::Git::NoSuchShaFound.new('abc123')
puts err.is_a?(StandardError)
puts err.message

# --- Module-level no-ops return nil ---
puts Gollum.set_git_timeout(30).nil?
puts Gollum.set_git_max_filesize(1_048_576).nil?

# --- Index treemap: pure-Ruby path-splitting logic ---
class FakeRawIndex
  def add(*); end
  def remove(*); end
  def remove_all(*); end
  def write_tree; '0' * 40; end
end
class FakeRawRepo
  def write(data, _kind); '0' * 40; end
  def index; FakeRawIndex.new; end
end

idx = Gollum::Git::Index.new(FakeRawIndex.new, FakeRawRepo.new)
idx.send(:update_treemap, 'docs/readme.txt', 'hello')
idx.send(:update_treemap, 'docs/notes.md',   'world')
idx.send(:update_treemap, '/lib/app.rb',     'code')
puts idx.tree.keys.sort.inspect
puts idx.tree['docs'].keys.sort.inspect
puts idx.tree['lib']['app.rb']
