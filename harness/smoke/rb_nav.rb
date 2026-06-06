require 'rb_nav'

# rb_nav is a Vim plugin helper. Its Ruby lib is minimal:
# only RbNav::VERSION is public. The real logic lives in bin/
# scripts (rb_nav_classes, rb_nav_methods) which parse grep output
# from STDIN. We replicate that logic here to exercise the same
# string-processing the gem ships.

puts RbNav::VERSION

# --- replicate rb_nav_classes parsing logic ---
grep_output = [
  "app/models/user.rb:3:class User < ApplicationRecord",
  "app/models/post.rb:1:class Post < ActiveRecord::Base",
  "lib/my_module.rb:5:module MyModule",
  "app/controllers/users_controller.rb:1:class UsersController < ApplicationController",
  "lib/singleton.rb:10:class << self",
]

xs = grep_output.map { |x|
  parts = x.strip.split(/:/, 3)
  path, line, klass = *parts
  klass = klass ? klass.strip.sub(/^\w+\s/, '') : "no class"
  klass = klass.sub(/\s*<\s*[A-Z]\S+/, '')
  if klass =~ /<<\s*self/
    nil
  else
    [klass, [path, line].join(':')]
  end
}.compact

max_width = xs.reduce(0) { |max, x| [x[0].length, max].max }
xs.each do |x|
  klass, path = *x
  puts "%-#{max_width}s %s" % [klass, path]
end

# --- replicate rb_nav_methods parsing logic ---
puts "---"
method_lines = [
  "12:  def initialize(name, age)",
  "20:  def full_name",
  "35:  def self.find_by_name",
]

ys = method_lines.map { |x|
  line, method = *x.strip.split(/:/)
  method = method.strip.sub(/^\s*def\s*/, '')
  [method, line]
}

max_width2 = ys.reduce(0) { |max, x| [x[0].length, max].max }
ys.each do |x|
  method, line = *x
  puts "%-#{max_width2}s %s" % [method, line]
end
