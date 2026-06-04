# Smoke: html-attributes-utils
# Exercises deep_merge_html_attributes and deep_tidy_html_attributes
# from the HTMLAttributesUtils refinement module.
#
# This gem requires active_support/core_ext/hash/keys for deep_symbolize_keys
# and active_support/core_ext/object/blank for String#presence.

require 'html_attributes_utils'

using HTMLAttributesUtils

# Test 1: class attribute strings are split and merged (deduplicated)
h1 = { class: 'btn btn-primary', id: 'submit-btn' }
h2 = { class: 'active btn-primary', id: 'cancel-btn' }
result1 = h1.deep_merge_html_attributes(h2)
puts result1[:class].sort.inspect
puts result1[:id].inspect

# Test 2: aria attributes with space-separated values are merged
h3 = { aria: { describedby: 'hint-1 hint-2' } }
h4 = { aria: { describedby: 'hint-3' } }
result2 = h3.deep_merge_html_attributes(h4)
puts result2.dig(:aria, :describedby).sort.inspect

# Test 3: deep nested merge
h5 = { class: 'container', data: { controller: 'form', value: 'old' } }
h6 = { class: 'wrapper', data: { controller: 'modal', extra: 'new' } }
result3 = h5.deep_merge_html_attributes(h6)
puts result3[:class].sort.inspect
puts result3.dig(:data, :controller).inspect
puts result3.dig(:data, :value).inspect
puts result3.dig(:data, :extra).inspect

# Test 4: deep_tidy_html_attributes removes nils, blanks, empty arrays
dirty = {
  class: 'container',
  title: nil,
  lang: '   ',
  rel: [],
  hidden: false,
  aria: { label: 'ok', describedby: [] }
}
tidy = dirty.deep_tidy_html_attributes
puts tidy[:class].inspect
puts tidy.key?(:title).inspect
puts tidy.key?(:lang).inspect
puts tidy[:hidden].inspect
puts tidy.dig(:aria, :label).inspect
