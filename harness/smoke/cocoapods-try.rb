require_relative "lib/cocoapods_try"
puts CocoapodsTry::VERSION
puts CocoapodsTry::VERSION.class
puts CocoapodsTry::VERSION.frozen?
puts CocoapodsTry::VERSION.split('.').length
puts CocoapodsTry::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? 'semver' : 'other'
