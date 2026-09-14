# FILED as matz/spinel#3321 (2026-07-24). FIXED upstream same day (79fdd68e);
# verified at 681b08ae — compiles, prints 1.0.0; the dir gem re-earns ★.
class Dir
  VERSION = '1.0.0'
end
puts Dir::VERSION
