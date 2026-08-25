# Regression (built at c51b0a1c, fails at 55638986): a module-ivar hash
# `@reg ||= {}` written through a poly-typed key in one method and read by a
# String key in another unifies to two incompatible C hash variants —
#   polyglot.rb:2: error: assignment to 'sp_PolyPolyHash *' from incompatible
#   pointer type 'sp_StrPolyHash *' [-Werror=incompatible-pointer-types]
# Reduced from the polyglot 0.3.5 gem (@registrations). Same poly-hash-variant
# unification family as matz/spinel#3975 (fixed b56e23f4) — likely a residual
# the Sym/Str fix didn't cover (here it's String-key vs poly-key, compile-time).
# FILED matz/spinel#4111 (2026-08-25).
module M
  @reg ||= {}
  def self.register(extension, klass)
    extension = [extension] unless Array === extension
    extension.each { |e| @reg[e] = klass }
  end
  def self.find(path)
    @reg[path.gsub(/.*\./, '')]
  end
end
M.register("rb", Object)
p M.find("x.rb")
