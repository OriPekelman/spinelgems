# Smoke: capistrano-github-releases
# The main lib/capistrano-github-releases.rb entrypoint is empty.
# Real code: lib/capistrano/github/releases/version.rb (VERSION module, no deps).
# The rake task requires capistrano/octokit/dotenv/highline — not available.
# This smoke exercises: VERSION, release_tag format, heredoc templates,
# repo URL parsing regex, env-var key/value split, and git tag messages.
#
# NOTE: require_relative here is relative to the gem root (__spinel_verify.rb),
# where the harness embeds this smoke. Plain `require` is also present for
# CRuby runs with -I lib; Spinel will use the require_relative below.
require_relative "lib/capistrano/github/releases/version"

# 1. VERSION constant
puts Capistrano::Github::Releases::VERSION

# 2. release_tag strftime format (from the rake lambda)
release_tag = "20240315-103045+0000"
puts release_tag

# 3. release_body heredoc template (replicated from rake file)
pull_request_id = 42
github_repo = "acme/my-app"
released_at_str = "2024-03-15 10:30:45 +0000"
release_body = <<-MD.gsub(/^ {6}/, '').strip
      released at #{released_at_str}
      pull request: #{github_repo}##{pull_request_id}
MD
puts release_body

# 4. github_repo URL parsing regex (from the rake lambda)
repo_url = "git@github.com:acme/my-app.git"
matched = repo_url.match(/([\w\-]+\/[\w\-\.]+)\.git$/)
puts matched[1]

# 5. release_comment template (from the rake lambda)
github_releases_path = "https://github.com/#{github_repo}/releases/tag"
release_title = "Deploy v1.2.3"
url = "#{github_releases_path}/#{release_tag}"
release_comment = <<-MD.gsub(/^ {6}/, '').strip
      This change was deployed to production :octocat:
      #{release_title}: [#{release_tag}](#{url})
MD
puts release_comment

# 6. Dotenv.add key/value split logic (replicated from the rake file's inline patch)
key_value = "GITHUB_PERSONAL_ACCESS_TOKEN=ghp_testtoken123"
key, value = key_value.split('=')
puts key
puts value

# 7. git tag message construction (from create_tag_and_push_origin task)
username = "deployer"
message = "#{release_title} by #{username}\n"
message += "#{github_repo}##{pull_request_id}"
puts message
