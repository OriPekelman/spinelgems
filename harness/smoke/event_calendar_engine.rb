# Smoke: event_calendar_engine 0.2.15
# Pure Rails Engine: lib/ only defines EventCalendar::Engine < Rails::Engine.
# Rails::Engine is unavailable in the Spinel smoke environment and cannot be
# stubbed before the harness require_relative in --full mode. The gem's
# EventInstanceMethods mixin lives in app/models/ (outside lib/) and is never
# loaded by the harness. Result: smoke-error:cruby — gem is not self-contained.

puts "event_calendar_engine: Rails-Engine-only gem — no standalone lib/ logic"
puts "ASSET_PREFIX would be: event_calendar"
