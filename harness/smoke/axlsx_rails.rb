# frozen_string_literal: true
# Smoke test for axlsx_rails -- exercises real public logic without Rails runtime.
# axlsx_rails is a Rails plugin; its core logic is the AxlsxBuilder template handler
# (StringIO-based code generation) and the VERSION constant.
# We stub the action_view require so we can load the class without Rails installed.

require 'stringio'

# Stub out action_view so template_handler.rb's `require 'action_view'` is a no-op
$LOADED_FEATURES << 'action_view'

# Provide minimal ActionView namespace that template_handler.rb reuses
module ActionView
  module Template
    module Handlers
    end
  end
end

GEM_LIB = File.expand_path('../../../../lib', __FILE__)
$LOAD_PATH.unshift(GEM_LIB)

require 'axlsx_rails/version'
require 'axlsx_rails/template_handler'

# --- 1. VERSION constant ---
puts "VERSION: #{AxlsxRails::VERSION}"

# --- 2. AxlsxBuilder class identity ---
handler = ActionView::Template::Handlers::AxlsxBuilder.new
puts "handler class: #{handler.class}"

# --- 3. call(template) -- code generation from a template object ---
# The call method returns a Ruby source string that sets up an Axlsx::Package
# and runs the template source inside it. We verify the generated code structure.

fake_template = Object.new
def fake_template.source
  'wb = xlsx_package.workbook; wb.add_worksheet(name: "Sheet1") { |ws| ws.add_row ["Hello", 42] }'
end

generated = handler.call(fake_template)
puts "generated is String: #{generated.is_a?(String)}"

axlsx_require = "require 'axlsx';"
puts "starts with require axlsx: #{generated.start_with?(axlsx_require)}"
puts "contains Package.new: #{generated.include?('Axlsx::Package.new')}"
puts "contains xlsx_author var: #{generated.include?('xlsx_author =')}"
puts "contains xlsx_created_at var: #{generated.include?('xlsx_created_at =')}"
puts "contains use_shared_strings var: #{generated.include?('xlsx_use_shared_strings =')}"
puts "contains template source: #{generated.include?('ws.add_row')}"

stream_suffix = ';xlsx_package.to_stream.string;'
puts "ends with to_stream: #{generated.end_with?(stream_suffix)}"
puts "generated length: #{generated.length}"

# --- 4. call(template, explicit_source) -- second arity uses given source instead ---
generated2 = handler.call(fake_template, 'puts "explicit source"')
puts "explicit source used: #{generated2.include?('puts "explicit source"')}"
puts "original template NOT used: #{!generated2.include?('ws.add_row')}"

# --- 5. call produces stable/deterministic output ---
generated3 = handler.call(fake_template)
puts "deterministic: #{generated == generated3}"
