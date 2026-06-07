require 'mason'
require 'mason/version'
require 'digest/sha1'
require 'uri'

# Mason::VERSION
puts Mason::VERSION

# Mason::CommandFailed is a StandardError subclass
err = Mason::CommandFailed.new("build step failed")
puts err.message
puts err.is_a?(StandardError)
puts err.is_a?(Mason::CommandFailed)

# Exercise URI + Digest::SHA1 logic mirrored from Mason::Buildpacks.install
url = "https://github.com/heroku/buildpack-ruby.git"
uri = URI.parse(url)
if uri.path =~ /buildpack-(\w+)/
  name = $1
  hash_prefix = Digest::SHA1.hexdigest(url).to_s[0..8]
  ad_hoc_name = "#{name}-#{hash_prefix}"
  puts name
  puts ad_hoc_name.length > 0
end

# Mason::Buildpacks path helpers (no filesystem side effects)
root = File.expand_path("~/.mason/buildpacks")
ad_hoc_root = File.expand_path("~/.mason/buildpacks-ad-hoc")
puts root.end_with?(".mason/buildpacks")
puts ad_hoc_root.end_with?(".mason/buildpacks-ad-hoc")
