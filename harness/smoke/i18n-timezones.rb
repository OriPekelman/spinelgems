# Smoke: i18n-timezones — structural API check
# The gem patches ActiveSupport::TimeZone#to_s (no dep on calling I18n/ActiveSupport internals)

puts ActiveSupport.class
puts ActiveSupport::TimeZone.class
puts ActiveSupport::TimeZone.superclass
puts ActiveSupport::TimeZone.instance_methods(false).sort.inspect
puts ActiveSupport::TimeZone.instance_method(:to_s).owner
