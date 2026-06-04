# frozen_string_literal: true

require 'ddplugin'

# Define a base plugin class and extend it with the Plugin module
class Formatter
  extend DDPlugin::Plugin
end

# Define concrete formatter subclasses with identifiers
class MarkdownFormatter < Formatter
  extend DDPlugin::Plugin
  identifier :markdown
end

class HtmlFormatter < Formatter
  extend DDPlugin::Plugin
  identifiers :html, :htm
end

class PlainFormatter < Formatter
  extend DDPlugin::Plugin
  identifier :plain
end

# Exercise Plugin#named (find by identifier)
md = Formatter.named(:markdown)
puts md.name

html = Formatter.named(:html)
puts html.name

htm = Formatter.named(:htm)
puts htm.name

# Exercise Plugin#identifiers (get identifiers of a class)
puts HtmlFormatter.identifiers.sort.inspect

# Exercise Plugin#identifier (first identifier)
puts MarkdownFormatter.identifier.inspect

# Exercise Plugin#all (enumerate all registered classes)
all = Formatter.all.map(&:name).sort
puts all.inspect

# Exercise Plugin#root_class
puts MarkdownFormatter.root_class.name

# named returns nil for unknown identifier
puts Formatter.named(:nonexistent).inspect

# Demonstrate a second independent plugin hierarchy
class Filter
  extend DDPlugin::Plugin
end

class StripFilter < Filter
  extend DDPlugin::Plugin
  identifiers :strip, :trim
end

puts Filter.named(:strip).name
puts StripFilter.root_class.name
puts StripFilter.identifiers.sort.inspect
