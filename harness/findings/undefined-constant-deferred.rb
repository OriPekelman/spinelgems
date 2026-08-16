# Hardening finding: a constant that is undefined ANYWHERE in the whole
# program compiles silently (no error, no warning) and defers to a runtime
# `uninitialized constant` NameError — while an unresolved METHOD call on a
# known receiver is already a compile-time refusal. Same closed-world
# analyzer, inconsistent treatment. Engine git:d61264ea.
#
#   $ spinel undefined-constant-deferred.rb -o /tmp/u.bin   # BUILDS, silent
#   $ /tmp/u.bin                                            # uninitialized constant Maidenhead (NameError)
#
# Uniform across positions (top-level, method body, bare read, is_a?).
# Contrast — this REFUSES at compile time, no binary:
#   class Foo; def self.a; 1; end; end
#   puts Foo.totally_undefined_method(3)
#   #=> spinel: unsupported ... CallNode `totally_undefined_method` ...
#
# Matches CRuby's RUNTIME semantics (CRuby also NameErrors at runtime), so
# not a correctness divergence — the ask is compile-time detection given the
# closed-world model. This deferral is what masked matz/spinel#3969 (a tep
# require-inliner bug that dropped a gem) as an engine bug.
puts Maidenhead
