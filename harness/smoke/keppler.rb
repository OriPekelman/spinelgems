require 'keppler'

# keppler is a Rails CMS CLI gem (uses Thor + system() calls).
# The lib loads only VERSION without external deps.
# The installer scripts contain pure-Ruby string transformation logic
# that mirrors what the CLI does when generating project scaffolds.
# We exercise those patterns here.

puts Keppler::VERSION

# These string transformations are used throughout keppler's installer scripts
# to derive module/namespace names from rocket plugin names.
rocket_names = %w[keppler_products keppler_blog keppler_contact_us]

rocket_names.each do |project|
  # capitalize each word (used for human-readable names)
  human = project.split('_').map(&:capitalize).join(' ')
  # drop the 'keppler_' prefix for scoping (used in routes, locales)
  scoped = project.split('_').drop(1).join('_')
  # hyphenated form (used in locale keys)
  hyphenated = project.gsub('_', '-')
  # CamelCase module name (used in engine/controller namespacing)
  camel = project.split('_').map(&:capitalize).join('')
  # sub-scope without prefix, concatenated (used in route scope names)
  sub_scope = project.split('_').drop(1).join('')

  puts "#{project}: human=#{human} scoped=#{scoped} hyphen=#{hyphenated} camel=#{camel} sub=#{sub_scope}"
end

# Verify the version constant is correctly formed (semver)
parts = Keppler::VERSION.split('.')
puts "version_parts=#{parts.length}"
puts "major=#{parts[0]}"
