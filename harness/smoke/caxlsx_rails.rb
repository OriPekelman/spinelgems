# frozen_string_literal: true
# Smoke: caxlsx_rails — TemplateHandler#call code generation
# Exercises real logic: StringIO assembly, source injection, variable guards.
# Skips Railtie/ActionController (require Rails); just loads template_handler directly.

require 'stringio'
require 'axlsx_rails/template_handler'
require 'axlsx_rails/version'

# --- TemplateHandler#call ---
handler = AxlsxRails::TemplateHandler.new

# Mock template object that provides a .source method
mock_template = Object.new
def mock_template.source
  "ws = xlsx_package.workbook.add_worksheet(name: 'FromTemplate'); ws.add_row ['hello', 42];"
end

# 1. Call with just a template (no explicit source)
code1 = handler.call(mock_template)
puts "RESULT call(template):"
puts "has require caxlsx: #{code1.include?("require 'caxlsx'")}"
puts "has xlsx_package new: #{code1.include?('Axlsx::Package.new')}"
puts "has to_stream: #{code1.include?('xlsx_package.to_stream.string')}"
puts "has xlsx_author guard: #{code1.include?('xlsx_author = defined?(xlsx_author)')}"
puts "contains template source: #{code1.include?('FromTemplate')}"
puts "code length > 100: #{code1.length > 100}"

# 2. Call with explicit source that overrides template
explicit_src = "ws2 = xlsx_package.workbook.add_worksheet(name: 'ExplicitSheet');"
code2 = handler.call(mock_template, explicit_src)
puts "\nRESULT call(template, source):"
puts "explicit source present: #{code2.include?('ExplicitSheet')}"
puts "template source overridden: #{!code2.include?('FromTemplate')}"

# 3. VERSION constant
puts "\nVERSION: #{AxlsxRails::VERSION}"
puts "version format ok: #{AxlsxRails::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? true : false}"

# 4. Generated code is a String (StringIO#string returns String)
puts "\ncode1 is String: #{code1.is_a?(String)}"
puts "code2 is String: #{code2.is_a?(String)}"

# 5. Multiple handler instances are independent
handler2 = AxlsxRails::TemplateHandler.new
code3 = handler2.call(mock_template, "puts 'independent';")
puts "\nIndependent handler has independent src: #{code3.include?("puts 'independent'")}"
puts "Independent handler no ExplicitSheet: #{!code3.include?('ExplicitSheet')}"
