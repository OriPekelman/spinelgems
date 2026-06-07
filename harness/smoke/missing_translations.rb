require 'missing_translations'

# The entry point only requires railtie when Rails is available,
# so we require the implementation files directly.
require 'hash_keys_dumper'

# Exercise HashKeysDumper.dump with a nested hash
flat = MissingTranslations::HashKeysDumper.dump({
  'en' => {
    'greeting' => 'Hello',
    'farewell' => 'Goodbye'
  },
  'fr' => 'Bonjour'
})
puts flat.sort.inspect

# Deeper nesting
deep = MissingTranslations::HashKeysDumper.dump({
  'a' => {
    'b' => {
      'c' => 'leaf'
    },
    'd' => 'also_leaf'
  },
  'x' => 'top'
})
puts deep.sort.inspect

# Symbol keys (to_s is called on keys)
sym = MissingTranslations::HashKeysDumper.dump({
  foo: { bar: 'val', baz: 'val2' },
  qux: 'plain'
})
puts sym.sort.inspect
