# frozen_string_literal: true
# Smoke: ruby-lsp-rails
# Exercises the self-contained support constants (Associations, Callbacks).
# The main entry point loads only the version; we also load the support
# modules (which have no external deps) to exercise real logic.

require "ruby-lsp-rails"   # loads RubyLsp::Rails::VERSION

# Load self-contained support modules via plain require (on the gem load path)
require "ruby_lsp/ruby_lsp_rails/support/associations"
require "ruby_lsp/ruby_lsp_rails/support/callbacks"

puts RubyLsp::Rails::VERSION

# --- Associations::ALL ---
assoc = RubyLsp::Rails::Support::Associations::ALL
puts assoc.length
puts assoc.frozen?
puts assoc.sort.join(",")

# --- Callbacks ---
cb = RubyLsp::Rails::Support::Callbacks

# Sub-group membership checks
puts cb::MODELS.include?("before_save")
puts cb::CONTROLLERS.include?("before_action")
puts cb::JOBS.include?("before_perform")
puts cb::MAILBOX.include?("before_processing")

# ALL is the concatenation of the four groups
puts cb::ALL.length
puts cb::ALL.frozen?
puts cb::ALL.include?("after_commit")       # MODELS
puts cb::ALL.include?("skip_before_action") # CONTROLLERS
puts cb::ALL.include?("around_enqueue")     # JOBS
puts cb::ALL.include?("around_processing")  # MAILBOX

# The four sub-group sizes must sum to ALL
expected = cb::MODELS.length + cb::CONTROLLERS.length + cb::JOBS.length + cb::MAILBOX.length
puts expected == cb::ALL.length
