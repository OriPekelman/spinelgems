# frozen_string_literal: true

# rename-rails: Rails generator gem for renaming a Rails application.
# require 'rename_rails' fails even under CRuby because the main entry point
# has a bug: it autoloads VERSION from "active_admin/version" (wrong path).
# All substantive logic (CommonMethods, AppToGenerator) requires Rails + Thor +
# ActiveSupport at runtime. Only rename_rails/version is standalone.

require 'rename_rails/version'

# Module identity
puts RenameRails.name
puts RenameRails::VERSION

# The string transformation logic used in prepare_app_vars is inline Rails/AS.
# Reproduce it in pure Ruby to show what the gem computes:
new_name = "my awesome app"
new_key = new_name.gsub(/\W/, "_")
puts new_key

# squeeze repeated underscores (camelize is ActiveSupport, do it manually)
squeezed = new_key.squeeze("_")
puts squeezed

camelized = squeezed.split("_").map(&:capitalize).join
puts camelized

new_dir = new_name.gsub(%r{[&%*@()!{}\[\]'\\/"]+}, "")
puts new_dir

# reserved names check (from common_methods.rb#reserved_names)
reserved = %w[application destroy benchmarker profiler plugin runner test]
puts reserved.include?(camelized.downcase).to_s
puts reserved.include?("application").to_s
