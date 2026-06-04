# Smoke test for gitlab-flowdock-git-hook
# Tests Flowdock::Git::Commit and Flowdock::Git::Builder pure Ruby logic.
# Stubs unavailable runtime deps (grit, flowdock, multi_json) so the pure logic
# is exercisable without network or native extensions.

require 'cgi'
require 'securerandom'

# Stub grit so builder.rb's `require 'grit'` doesn't blow up.
module Grit; end
$LOADED_FEATURES << 'grit.rb' unless $LOADED_FEATURES.include?('grit.rb')
# Ensure require 'grit' is a no-op
module Kernel
  alias_method :_orig_require_gfgit, :require
  def require(name)
    return true if name == 'grit'
    _orig_require_gfgit(name)
  end
end

GEM_LIB = File.expand_path('~/.cache/spinel-compat/gems/gitlab-flowdock-git-hook-1.0.1/lib')

# Pre-define Flowdock::Git so Commit/Builder can be nested inside it
module Flowdock
  class Git
  end
end

load File.join(GEM_LIB, 'flowdock/git/builder.rb')

# --- Test Flowdock::Git::Commit#to_hash ---

commit_data = {
  id: 'a1b2c3d4e5f6789abcdef0123456789abcdef01',
  message: "Fix memory leak in parser\n\nDetailed description of the fix.",
  author: { name: 'Jane Dev', email: 'jane@example.com' },
  url: 'https://git.example.com/commit/%s'
}

thread = { title: 'myrepo branch main', external_url: 'https://git.example.com/myrepo' }
tags   = ['deploy', 'production']

commit_obj = Flowdock::Git::Commit.new('refs/heads/main', thread, tags, commit_data)
h = commit_obj.to_hash

puts "event:#{h[:event]}"
puts "author_name:#{h[:author][:name]}"
puts "author_email:#{h[:author][:email]}"
puts "tags:#{h[:tags].join(',')}"
# title includes first 7 chars of commit sha
puts "title_has_sha:#{h[:title].include?('a1b2c3')}"
# body wraps remaining message in <pre>
puts "body_has_pre:#{h[:body].include?('<pre>')}"

# --- Test Flowdock::Git::Builder#ref_name ---

stub_builder = Flowdock::Git::Builder.new(
  repo: nil,
  ref: 'refs/heads/feature/my-branch',
  before: 'abc',
  after: 'def',
  permanent_refs: [/refs\/heads\/master/, /refs\/heads\/main/],
  repo_name: 'myrepo',
  repo_url: 'https://git.example.com/myrepo',
  commit_url: nil,
  tags: ['ci']
)

puts "ref_name:#{stub_builder.ref_name}"

tag_builder = Flowdock::Git::Builder.new(
  repo: nil,
  ref: 'refs/tags/v1.2.3',
  before: nil,
  after: nil,
  permanent_refs: [],
  repo_name: 'myrepo',
  repo_url: nil,
  commit_url: nil,
  tags: []
)
puts "tag_ref_name:#{tag_builder.ref_name}"

# --- Test CGI html escaping (used in Commit#message_title) ---
escaped = CGI.escape_html('<script>alert("xss")</script>')
puts "html_escape:#{escaped}"

# --- Test encode_as_utf8 logic via Commit with non-ASCII ---
commit_latin = {
  id: 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef',
  message: "Add caf\xE9 support",
  author: { name: "Andr\xE9", email: 'andre@example.com' },
  url: nil
}
commit_latin[:message].force_encoding('ISO-8859-1')
commit_latin[:author][:name].force_encoding('ISO-8859-1')
h2 = Flowdock::Git::Commit.new('refs/heads/main', thread, [], commit_latin).to_hash
puts "utf8_name:#{h2[:author][:name]}"
puts "encoding_ok:#{h2[:author][:name].encoding == Encoding::UTF_8}"
