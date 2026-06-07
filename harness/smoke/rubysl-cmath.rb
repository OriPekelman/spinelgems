require 'rubysl/cmath'

# CMath provides Math functions extended to the complex domain.
# Test real and complex inputs across key methods.

# --- sqrt: real negative and complex ---
r1 = CMath.sqrt(-1)
puts "sqrt(-1): #{r1}"                        # => (0+1i)

r2 = CMath.sqrt(Complex(0, 2))
puts "sqrt(0+2i): #{r2.real.round(6)} #{r2.imag.round(6)}"

# --- exp of complex ---
r3 = CMath.exp(Complex(0, Math::PI))
puts "exp(i*pi) real: #{r3.real.round(6)}"    # => -1.0
puts "exp(i*pi) imag: #{r3.imag.round(6)}"    # => ~0.0

# --- log of negative real ---
r4 = CMath.log(-1)
puts "log(-1) real: #{r4.real.round(6)}"      # => 0.0
puts "log(-1) imag: #{r4.imag.round(6)}"      # => ~3.141593

# --- sin and cos with complex argument ---
z = Complex(1, 1)
r5 = CMath.sin(z)
puts "sin(1+i) real: #{r5.real.round(6)}"
puts "sin(1+i) imag: #{r5.imag.round(6)}"

r6 = CMath.cos(z)
puts "cos(1+i) real: #{r6.real.round(6)}"
puts "cos(1+i) imag: #{r6.imag.round(6)}"

# --- log2 and log10 of complex ---
r7 = CMath.log2(Complex(-1, 0))
puts "log2(-1) imag round: #{(r7.imag / Math::PI).round(6)}"  # => ~1.442695

r8 = CMath.log10(Complex(0, 1))
puts "log10(i) real: #{r8.real.round(6)}"
puts "log10(i) imag: #{r8.imag.round(6)}"

# --- cbrt of complex ---
r9 = CMath.cbrt(Complex(8, 0))
puts "cbrt(8+0i) real: #{r9.real.round(6)}"  # => ~2.0

# --- asin outside [-1,1] ---
r10 = CMath.asin(2)
puts "asin(2) real: #{r10.real.round(6)}"
puts "asin(2) imag: #{r10.imag.round(6)}"
