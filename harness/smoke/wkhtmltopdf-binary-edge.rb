# smoke: wkhtmltopdf-binary-edge-alpine
# Exercises platform-detection logic and binary-path resolution.
# The gem's lib is an empty stub; real Ruby logic lives in bin/wkhtmltopdf.
require 'wkhtmltopdf-binary-edge-alpine'

# --- 1. Platform detection (copied from bin/wkhtmltopdf) ---
arch = case RUBY_PLATFORM
       when /64.*linux/
         RUBY_PLATFORM.match?(/linux-musl/) ? 'alpine-linux-amd64' : 'linux-amd64'
       when /darwin/
         'darwin-x86_64'
       else
         'unsupported'
       end

puts "RUBY_PLATFORM: #{RUBY_PLATFORM}"
puts "resolved_arch: #{arch}"

# --- 2. Binary path resolution ---
# $LOAD_PATH[0] is the gem's lib dir after require
lib_dir = $LOAD_PATH.find { |p| p.include?('wkhtmltopdf-binary-edge-alpine') }
gem_root = lib_dir ? File.expand_path('..', lib_dir) : nil

if gem_root
  binary_path = File.join(gem_root, 'libexec', "wkhtmltopdf-#{arch}")
  puts "binary_exists: #{File.exist?(binary_path)}"
  puts "binary_executable: #{File.executable?(binary_path)}"
  puts "binary_name: #{File.basename(binary_path)}"
else
  # Fallback: derive from __FILE__ location
  puts "binary_exists: unknown (load_path lookup failed)"
end

# --- 3. String manipulation: arch suffix extraction ---
suffix = arch.split('-').last
puts "arch_suffix: #{suffix}"

# --- 4. Platform-group classification ---
group = if arch.include?('alpine')
          'musl'
        elsif arch.include?('linux')
          'glibc'
        elsif arch.include?('darwin')
          'macos'
        else
          'other'
        end
puts "platform_group: #{group}"
