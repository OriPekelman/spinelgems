# smoke: lyb_devise_admin — a Rails engine (admin UI for Devise).
# The top-level lib file only conditionally loads Railtie when Rails is present.
# We load the gem entry point, then load sub-files that have no Rails dependency:
#   - lib/lyb_devise_admin/version.rb  → LybDeviseAdmin::VERSION
#   - app/helpers/devise_helper.rb     → DeviseHelper#roles_for_collection

require 'lyb_devise_admin'

# Explicitly load version (skipped by main entry point without Rails)
require_relative '/home/oripekelman/.cache/spinel-compat/gems/lyb_devise_admin-0.4.0/lib/lyb_devise_admin/version'

# Load the helper (pure Ruby — caller must supply Role)
require_relative '/home/oripekelman/.cache/spinel-compat/gems/lyb_devise_admin-0.4.0/app/helpers/devise_helper'

# Stub Role model for roles_for_collection
class Role
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def self.all
    [new('superadmin'), new('editor'), new('reader')]
  end
  def to_s
    @name.split('_').map(&:capitalize).join(' ')
  end
end

# Exercise DeviseHelper#roles_for_collection — real method logic
obj = Object.new
obj.extend(DeviseHelper)
pairs = obj.roles_for_collection

pairs.each do |display, key|
  puts "display=#{display} key=#{key}"
end

puts "pair_count=#{pairs.length}"
puts "VERSION=#{LybDeviseAdmin::VERSION}"
