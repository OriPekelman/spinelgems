# frozen_string_literal: true
require 'htmlascii'

# Basic ASCII numeric entities
puts Htmlascii.convert('&#72;&#101;&#108;&#108;&#111;')  # Hello

# Mixed text and entities
puts Htmlascii.convert('Price&#58; &#36;&#52;&#57;')     # Price: $49

# Latin extended characters
puts Htmlascii.convert('caf&#233;')                        # café

# Math symbols
puts Htmlascii.convert('&#8734; &#8800; &#8804;')          # ∞ ≠ ≤

# Greek letters
puts Htmlascii.convert('&#945;&#946;&#947;')               # αβγ

# No-op: string with no entities stays unchanged
plain = 'no entities here'
puts Htmlascii.convert(plain)

# Non-breaking space entity
puts Htmlascii.convert('a&#160;b').length                  # 3
