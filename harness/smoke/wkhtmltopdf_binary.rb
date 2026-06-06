# Smoke: wkhtmltopdf_binary
# The gem's lib/wkhtmltopdf_binary.rb is intentionally empty (0 bytes).
# The gem is a binary-distribution package; all Ruby logic lives in
# exe/wkhtmltopdf (a thin platform-detection launcher).
# We exercise the platform-detection and arg-joining logic from that script.

require 'wkhtmltopdf_binary'

# Replicate the platform-detection branch from exe/wkhtmltopdf
platform = case RUBY_PLATFORM
           when /x86_64-linux.*/
             'x86_64-linux'
           when /x86_64-darwin.*/
             'x86_64-darwin'
           when /aarch64-linux.*/
             'aarch64-linux'
           when /arm64-darwin.*/
             'arm64-darwin'
           else
             'unsupported'
           end

puts "detected_platform: #{platform}"
puts "platform_supported: #{platform != 'unsupported'}"

# The exe script builds the binary path as "#{__FILE__}-#{platform}"
puts "exe_basename: wkhtmltopdf-#{platform}"

# Verify the ARGV-joining logic from the exe script:
# args = ARGV.inject('') { |result, arg| "#{result} #{arg}" }
sample_args = ["--quiet", "--page-size", "A4"]
joined = sample_args.inject('') { |result, arg| "#{result} #{arg}" }
puts "joined_args: '#{joined}'"
puts "joined_args_stripped: '#{joined.strip}'"
