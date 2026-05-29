# hamli smoke — VERSION constant + Hamli::Range API (no external deps)
puts Hamli::VERSION

source = "hello\nworld\nfoo"
r0 = Hamli::Range.new(index: 0, source: source)
puts r0.line_number
puts r0.column
puts r0.line

r7 = Hamli::Range.new(index: 7, source: source)
puts r7.line_number
puts r7.column
puts r7.line

# Errors class hierarchy (no instantiation needed)
puts Hamli::Errors::HamlSyntaxError.ancestors.include?(StandardError)
puts Hamli::Errors::MalformedIndentationError.superclass == Hamli::Errors::HamlSyntaxError
