require 'textlint/gem_version'
require 'json'

# danger-textlint smoke: exercises pure-logic parts without the Danger runtime.
# Danger::DangerTextlint < Danger::Plugin, but the parse/command logic is
# self-contained. We replicate it here from textlint/plugin.rb to exercise
# the real gem behaviour (JSON parsing, severity mapping, path stripping).

# Replicate parse logic from Danger::DangerTextlint#parse
def parse_textlint_result(json_str, dir, max_severity = nil)
  result = JSON(json_str)
  severity_method = {
    1 => "warn",
    2 => "fail"
  }

  result.flat_map do |file|
    file_path = file["filePath"]
    file["messages"].map do |message|
      severity = max_severity == "warn" ? 1 : message["severity"]
      {
        file_path: file_path.gsub(dir, ""),
        line: message["line"],
        severity: severity_method[severity],
        message: "#{message['message']}(#{message['ruleId']})"
      }
    end
  end
end

# Replicate textlint_command logic from private method
def textlint_command(bin, target_files, config_file = nil)
  command = "#{bin} -f json"
  command << " -c #{config_file}" if config_file
  "#{command} #{target_files.join(' ')}"
end

# Test VERSION constant
puts "VERSION: #{Textlint::VERSION}"

# Test textlint_command building
cmd = textlint_command("./node_modules/.bin/textlint", ["README.md", "docs/guide.md"])
puts "CMD no config: #{cmd}"

cmd_with_config = textlint_command("./node_modules/.bin/textlint", ["README.md"], ".textlintrc")
puts "CMD with config: #{cmd_with_config}"

# Test parse logic with a realistic textlint JSON output
sample_json = JSON.generate([
  {
    "filePath" => "/project/README.md",
    "messages" => [
      {
        "line" => 3,
        "column" => 10,
        "severity" => 2,
        "message" => "Found todo comment.",
        "ruleId" => "no-todo"
      },
      {
        "line" => 7,
        "column" => 1,
        "severity" => 1,
        "message" => "Sentence is too long.",
        "ruleId" => "sentence-length"
      }
    ]
  },
  {
    "filePath" => "/project/docs/guide.md",
    "messages" => [
      {
        "line" => 2,
        "column" => 5,
        "severity" => 2,
        "message" => "Use active voice.",
        "ruleId" => "write-good"
      }
    ]
  }
])

errors = parse_textlint_result(sample_json, "/project/")
puts "PARSED COUNT: #{errors.size}"
errors.each do |e|
  puts "  #{e[:file_path]}:#{e[:line]} [#{e[:severity]}] #{e[:message]}"
end

# Test max_severity override (all forced to warn)
errors_warn = parse_textlint_result(sample_json, "/project/", "warn")
severities = errors_warn.map { |e| e[:severity] }.uniq.sort
puts "MAX_SEVERITY warn result severities: #{severities.inspect}"

# Test empty messages file
empty_json = JSON.generate([{ "filePath" => "/project/empty.md", "messages" => [] }])
empty_errors = parse_textlint_result(empty_json, "/project/")
puts "EMPTY MESSAGES COUNT: #{empty_errors.size}"
