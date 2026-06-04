# flatpickr-datepicker-rails smoke
# The gem's main entry requires 'rails' (external), so we go straight to the
# version file (no external deps) and then manually open the module to confirm
# the version constant and module namespace are usable.

require_relative '/home/oripekelman/.cache/spinel-compat/gems/flatpickr-datepicker-rails-1.0.2/lib/flatpickr-datepicker-rails/version'

# Exercise the module + constant
puts FlatpickrDatePickerRails::VERSION
puts FlatpickrDatePickerRails::VERSION.split('.').map(&:to_i).inspect
puts FlatpickrDatePickerRails::VERSION >= '1.0.0'
puts FlatpickrDatePickerRails.name
puts FlatpickrDatePickerRails.is_a?(Module)
puts FlatpickrDatePickerRails.ancestors.include?(FlatpickrDatePickerRails)
