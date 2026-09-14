# Regression (built at c51b0a1c, fails at 55638986): assigning the result of
# `File.open(path) { |f| Marshal.load(f) }` to an ivar mis-types the File.open
# return as the File handle instead of the block's value —
#   cloc.rb:3: error: initialization of 'const char *' from incompatible
#   pointer type 'sp_File *' [-Werror=incompatible-pointer-types]
# Trigger is the block's UNTYPED return (Marshal.load); a String-returning
# block (f.read) or JSON.parse(f.read) compiles. Reduced from cloc 0.9.0.
# FILED matz/spinel#4112 (2026-08-25).
class D
  def load(path)
    @table = File.open(path) { |f| Marshal.load(f) }
  end
end
D.new.load("/tmp/x")
