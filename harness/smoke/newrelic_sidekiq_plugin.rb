# smoke: newrelic_sidekiq_plugin 0.0.4
# This gem is a single-file NewRelic Plugin agent for Sidekiq.
# lib/newrelic_sidekiq_agent.rb immediately requires "newrelic_plugin" and
# "sidekiq" at the top level; there is no standalone logic to exercise.
# Even CRuby cannot load it without a full dep chain (connection_pool, etc.).
# This is a smoke-error: the gem is an integration-only glue layer.

require 'newrelic_sidekiq_plugin'
