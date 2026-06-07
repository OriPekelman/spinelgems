require 'resin'
require 'resin/compiler'

# Define Resin.development? (normally provided by sinatra/resin,
# but that needs the sinatra gem which is not available)
module Resin
  def self.development?
    ENV['RACK_ENV'] != 'production'
  end
end

require 'json'
require 'resin/helpers'

# --- Resin::Compiler::CORE ---
puts "CORE count: #{Resin::Compiler::CORE.length}"
puts "First: #{Resin::Compiler::CORE.first}"
puts "Last: #{Resin::Compiler::CORE.last}"
puts "Includes Canvas: #{Resin::Compiler::CORE.include?('Canvas')}"

# --- Resin::Helpers.append_js_file: production mode ---
ENV['RACK_ENV'] = 'production'
prod = []
Resin::Helpers.append_js_file('/build/app.deploy.js', prod)          # included (has deploy, no -Tests)
Resin::Helpers.append_js_file('/build/Canvas-Tests.deploy.js', prod) # excluded (-Tests present)
Resin::Helpers.append_js_file('/build/plain.js', prod)               # excluded (no deploy)
puts "production files: #{prod.inspect}"

# --- Resin::Helpers.append_js_file: development mode ---
ENV['RACK_ENV'] = 'development'
dev = []
Resin::Helpers.append_js_file('/build/app.deploy.js', dev)  # excluded (has 'deploy')
Resin::Helpers.append_js_file('/build/plain.js', dev)       # included (no 'deploy')
Resin::Helpers.append_js_file('/build/extra.js', dev)       # included (no 'deploy')
puts "development files: #{dev.inspect}"
