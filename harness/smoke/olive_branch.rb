require 'olive_branch'

# olive_branch is a Rack middleware for camelCase/dash key inflection.
# The public surface is: OliveBranch::Checks (content-type guards) and
# OliveBranch::Transformations (recursive key-transformation engine).
# Middleware itself needs ActionDispatch + multi_json at runtime, so we
# exercise the two self-contained classes directly.
#
# NOTE: middleware.rb begins with `require "multi_json"`.  Spinel ignores
# plain cross-gem requires; a minimal multi_json.rb stub lives in the gem's
# own lib/ dir so CRuby can load the file too.

OliveBranch::Middleware  # trigger autoload (defines Checks + Transformations)

# 1. Checks.content_type_check — regex guard used by the middleware
puts OliveBranch::Checks.content_type_check('application/json')     ? 'ct:json'    : 'ct:json:nil'
puts OliveBranch::Checks.content_type_check('application/vnd.api+json') ? 'ct:vnd' : 'ct:vnd:nil'
puts OliveBranch::Checks.content_type_check('text/html').inspect

# 2. Checks.default_exclude — always returns false (passthrough default)
puts OliveBranch::Checks.default_exclude({'REQUEST_METHOD' => 'GET'}).inspect
puts OliveBranch::Checks.default_exclude({}).inspect

# 3. Transformations.transform — recursive dispatcher over Array / String / other
upcase_fn = ->(s) { s.upcase }

# Array of mixed types: strings are transformed, integers and nil are passed through
puts OliveBranch::Transformations.transform(['foo_bar', 42, nil, true], upcase_fn).inspect

# Nested arrays are flattened recursively
puts OliveBranch::Transformations.transform([['nested', 'items'], 'top'], upcase_fn).inspect

# Plain string
puts OliveBranch::Transformations.transform('hello_world', upcase_fn)

# Non-string, non-array, non-hash passes through unchanged
puts OliveBranch::Transformations.transform(99,   upcase_fn).inspect
puts OliveBranch::Transformations.transform(nil,  upcase_fn).inspect
puts OliveBranch::Transformations.transform(true, upcase_fn).inspect

# 4. A custom transform lambda (append suffix)
suffix_fn = ->(s) { "#{s}_key" }
puts OliveBranch::Transformations.transform(['first_name', 'last_name'], suffix_fn).inspect
puts OliveBranch::Transformations.transform('user_id', suffix_fn)
