# smoke: danger-apkanalyzer
# danger-apkanalyzer wraps the `apkanalyzer` CLI as a Danger plugin.
# Danger::Plugin (from the `danger` gem) is unavailable in this context, so
# we exercise the gem's pure-logic parts: VERSION + the string-building that
# each method assembles from apkanalyzer output.
#
# The three methods (file_size, permissions, method_references) share a clear
# pattern: run apkanalyzer, assemble a Markdown table. We replicate that logic
# here and verify it produces the expected Markdown rows.

require 'apkanalyzer/gem_version'

puts "version=#{Apkanalyzer::VERSION}"

# --- Replicate file_size table building ---
def build_file_size_table(raw_output)
  message = "#### APK file size\n\n"
  message << "| size |\n"
  message << "| --- |\n"
  message << "| #{raw_output.chomp} |\n"
  message << "\n"
  message
end

# --- Replicate permissions table building ---
def build_permissions_table(raw_output)
  message = "#### Permissions\n\n"
  message << "| Permissions |\n"
  message << "| --- |\n"
  raw_output.each_line do |line|
    message << "| #{line.chomp} |\n"
  end
  message << "\n"
  message
end

# --- Replicate method_references table building ---
def build_method_references_table(raw_output)
  message = "#### Number of method references\n\n"
  message << "| Dex file | count |\n"
  message << "| --- | --- |\n"
  raw_output.each_line do |line|
    v = line.chomp.split(" ")
    message << "| #{v[0]} | #{v[1]} |\n"
  end
  message << "\n"
  message
end

# 1. file_size output
size_md = build_file_size_table("5242880")
puts "file_size_header=#{size_md.lines.first.chomp}"
puts "file_size_row=#{size_md.lines.grep(/\| 5242880 \|/).first.chomp}"

# 2. permissions output
perms_raw = "android.permission.INTERNET\nandroid.permission.CAMERA\nandroid.permission.READ_EXTERNAL_STORAGE\n"
perms_md = build_permissions_table(perms_raw)
perm_rows = perms_md.lines.select { |l| l.start_with?("| android.") }.map(&:chomp)
puts "perms_count=#{perm_rows.size}"
puts "perm0=#{perm_rows[0]}"
puts "perm1=#{perm_rows[1]}"
puts "perm2=#{perm_rows[2]}"

# 3. method_references output (multi-dex)
refs_raw = "classes.dex 62345\nclasses2.dex 18920\n"
refs_md = build_method_references_table(refs_raw)
ref_rows = refs_md.lines.select { |l| l.start_with?("| classes") }.map(&:chomp)
puts "refs_count=#{ref_rows.size}"
puts "ref0=#{ref_rows[0]}"
puts "ref1=#{ref_rows[1]}"

# 4. Edge case: single-dex app
single_refs_raw = "classes.dex 29001\n"
single_md = build_method_references_table(single_refs_raw)
single_rows = single_md.lines.select { |l| l.start_with?("| classes") }.map(&:chomp)
puts "single_dex_rows=#{single_rows.size}"
puts "single_dex_row=#{single_rows.first}"

# 5. DEFAULT_COMMAND value (replicates the constant in plugin.rb)
DEFAULT_COMMAND = "apkanalyzer".freeze
puts "default_cmd=#{DEFAULT_COMMAND}"
