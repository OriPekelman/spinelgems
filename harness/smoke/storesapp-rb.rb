# smoke: storesapp-rb
# storesapp-rb is a Rails Engine / ActiveResource wrapper.
# lib/storesapp.rb requires 'rails' at the top; all model classes
# inherit from ActiveResource::Base.  We stub Rails + ActiveResource
# before loading the gem so we can verify the declared class structure.

# --- Minimal stubs for Rails + ActiveResource ---
module ActiveResource
  class Base
    def self.site=(v);     @site = v;    end
    def self.user=(v);     @user = v;    end
    def self.password=(v); @pass = v;    end
    def self.site;         @site;        end
  end
end

module Rails
  def self.root; "/tmp"; end
  def self.env;  "test"; end

  class PathSet
    def method_missing(name, *args)
      if name.to_s.end_with?("=")
        # setter — ignore
      else
        self
      end
    end
    def respond_to_missing?(*); true; end
  end

  class Engine
    def self.paths
      @paths ||= Rails::PathSet.new
    end
  end
end

# Mark 'rails' as already loaded so require 'rails' inside the gem is a no-op
$LOADED_FEATURES << "rails.rb"
$LOADED_FEATURES << "rails"

# Locate the gem
GEM_ROOT = "/home/oripekelman/.cache/spinel-compat/gems/storesapp-rb-0.2.9"
$LOAD_PATH.unshift File.join(GEM_ROOT, "lib")

require 'storesapp'

# Confirm the Engine module is wired under Storesapp
puts "Storesapp::Engine defined: #{defined?(Storesapp::Engine) ? 'yes' : 'no'}"
puts "Storesapp::Engine superclass: #{Storesapp::Engine.superclass.name}"

# Load model files manually (the gem doesn't auto-load outside Rails)
base_dir = File.join(GEM_ROOT, "app/models")
%w[base collection order_item_property order_item order page
   product_image product_property product shipping_rate store
   tax_rate user variant_property variant].each do |f|
  load File.join(base_dir, "#{f}.rb")
end

# Verify model classes exist and have correct ancestry
models = [Product, Order, Variant, Store, User, Collection]
models.each do |klass|
  ok = klass.ancestors.include?(ActiveResource::Base)
  puts "#{klass.name} < ActiveResource::Base: #{ok ? 'yes' : 'no'}"
end

# Verify the default API endpoint was set
puts "Base.site set: #{Base.site.to_s.include?('storesapp.com') ? 'yes' : 'no'}"
