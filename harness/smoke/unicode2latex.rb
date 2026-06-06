require 'unicode2latex'

# Test 1: convert Greek letters
text1 = "α + β = γ"
result1 = Unicode2LaTeX.unicode2latex(text1.dup)
puts result1

# Test 2: convert math symbols
text2 = "∀x ∈ ℝ: x² ≥ 0"
result2 = Unicode2LaTeX.unicode2latex(text2.dup)
puts result2

# Test 3: convert arrows
text3 = "→ ← ↔ ⇒"
result3 = Unicode2LaTeX.unicode2latex(text3.dup)
puts result3

# Test 4: fractions and subscripts
text4 = "½ + ¼ = ¾"
result4 = Unicode2LaTeX.unicode2latex(text4.dup)
puts result4

# Test 5: version constant
puts Unicode2LaTeX::VERSION

# Test 6: idempotent on plain ASCII (no substitution)
text6 = "hello world"
result6 = Unicode2LaTeX.unicode2latex(text6.dup)
puts result6
