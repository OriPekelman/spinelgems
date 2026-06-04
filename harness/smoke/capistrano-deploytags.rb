# Smoke: capistrano-deploytags
# Exercises CapistranoDeploytags::Helper tag/message logic.
# capistrano/deploytags.rb requires capistrano/deploy (not present) and loads a
# rake task file — both are stubbed so only the Helper class is loaded.

module Kernel
  alias_method :_cdt_orig_require, :require
  def require(path)
    return true if path == 'capistrano/deploy'
    _cdt_orig_require(path)
  end

  alias_method :_cdt_orig_load, :load
  def load(path)
    return true if path.end_with?('.rake')
    _cdt_orig_load(path)
  end
end

# Capistrano DSL injects `fetch` at the top level; provide a minimal stub.
$cdt_config = {
  deploytag_utc: true,
  deploytag_commit_message: false,
}
def fetch(key, default = nil)
  $cdt_config.key?(key) ? $cdt_config[key] : default
end

require 'capistrano/deploytags'

# --- git_tag_for: "<stage>-<timestamp>" ---
tag = CapistranoDeploytags::Helper.git_tag_for('production')
puts tag.start_with?('production-') ? "tag_prefix: ok" : "tag_prefix: FAIL (#{tag})"
puts tag.match?(/\Aproduction-\d{4}\.\d{2}\.\d{2}-\d{6}-utc\z/) \
  ? "tag_format: ok" : "tag_format: FAIL (#{tag})"

# --- formatted_time: "YYYY.MM.DD-HHmmss-utc" ---
ts = CapistranoDeploytags::Helper.formatted_time
puts ts.match?(/\A\d{4}\.\d{2}\.\d{2}-\d{6}-utc\z/) \
  ? "formatted_time: ok" : "formatted_time: FAIL (#{ts})"

# --- commit_message default: "<user> deployed <sha> to <stage>" ---
sha = 'deadbeef1234'
msg = CapistranoDeploytags::Helper.commit_message(sha, 'staging')
puts msg.include?(sha)       ? "msg_sha: ok"   : "msg_sha: FAIL (#{msg})"
puts msg.include?('staging') ? "msg_stage: ok" : "msg_stage: FAIL (#{msg})"
puts msg.match?(/deployed/)  ? "msg_verb: ok"  : "msg_verb: FAIL (#{msg})"

# --- commit_message with custom override ---
$cdt_config[:deploytag_commit_message] = 'Release v1.2.3 to production'
custom = CapistranoDeploytags::Helper.commit_message(sha, 'production')
puts custom == 'Release v1.2.3 to production' \
  ? "msg_custom: ok" : "msg_custom: FAIL (#{custom})"
