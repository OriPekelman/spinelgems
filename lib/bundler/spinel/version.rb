module Bundler
  module Spinel
    # 0.4.0: a gem's shipped `sig/*.rbs` acts as the Spinel type root —
    # `verify` auto-`--rbs`, `vendor` aggregates one root, retiring seed soup
    # (#13); opt-in (`"default":"disabled"`) build-units + variant `build_dir`
    # over a shared source for optional CUDA/Metal backends (#20); macOS SDK
    # libc++ path for cmake build-units (#21); and probe/engine robustness for
    # the b60fbd7 corpus reprobe (require-only → load-path limit; git rev for
    # worktrees/frozen copies).
    VERSION = "0.4.0"
  end
end
